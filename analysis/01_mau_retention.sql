模块一：用户活跃度与留存分析

USE content_platform;

-- 1. 每月活跃用户数（MAU）
SELECT
    DATE_FORMAT(action_date, '%Y-%m') AS month,
    COUNT(DISTINCT user_id) AS mau
FROM user_actions
GROUP BY DATE_FORMAT(action_date, '%Y-%m')
ORDER BY month;

-- 2. 次月留存率
SELECT
    reg_month,
    ROUND(SUM(is_retained) / COUNT(DISTINCT user_id) * 100, 1) AS retention_rate_pct
FROM (
    SELECT
        u.user_id,
        DATE_FORMAT(u.register_date, '%Y-%m') AS reg_month,
        CASE WHEN DATE_FORMAT(a.action_date, '%Y-%m')
                  = DATE_FORMAT(DATE_ADD(u.register_date, INTERVAL 1 MONTH), '%Y-%m')
             THEN 1 ELSE 0 END AS is_retained
    FROM users u
    LEFT JOIN user_actions a ON u.user_id = a.user_id
) t
GROUP BY reg_month
ORDER BY reg_month;
