模块三：旅游产品转化漏斗分析

USE content_platform;

各步骤用户数及转化率
SELECT
    step,
    user_count,
    step_order,
    LAG(user_count, 1) OVER (ORDER BY step_order) AS prev_step_count,
    ROUND(user_count / LAG(user_count, 1) OVER (ORDER BY step_order), 2) AS conversion_rate
FROM (
    SELECT
        step,
        COUNT(DISTINCT user_id) AS user_count,
        CASE WHEN step = 'view_product' THEN 1
             WHEN step = 'add_to_cart' THEN 2
             WHEN step = 'start_checkout' THEN 3
             WHEN step = 'paid' THEN 4
        END AS step_order
    FROM funnel_events
    GROUP BY step
) t
ORDER BY step_order;
