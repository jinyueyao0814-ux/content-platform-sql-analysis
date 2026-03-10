模块四：用户RFM分层

USE content_platform;

RFM打分与用户分层
SELECT
    user_id,
    R_score,
    F_score,
    M_score,
    R_score + F_score + M_score AS total_score,
    CASE WHEN R_score + F_score + M_score >= 7 THEN '高价值用户'
         WHEN R_score + F_score + M_score >= 5 THEN '中价值用户'
         ELSE '低价值用户'
    END AS user_segment
FROM (
    SELECT
        user_id,
        CASE WHEN R <= 20 THEN 3 WHEN R <= 50 THEN 2 ELSE 1 END AS R_score,
        CASE WHEN F >= 2 THEN 3 ELSE 1 END AS F_score,
        CASE WHEN M >= 10000 THEN 3 WHEN M >= 5000 THEN 2 ELSE 1 END AS M_score
    FROM (
        SELECT
            user_id,
            DATEDIFF('2023-05-31', MAX(order_date)) AS R,
            COUNT(*) AS F,
            SUM(gmv) AS M
        FROM travel_orders
        WHERE status = 'paid'
        GROUP BY user_id
    ) t
) t2
ORDER BY total_score DESC;
