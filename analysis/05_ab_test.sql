模块五：A/B测试分析

USE content_platform;

1. A/B两组整体点击率与转化率
SELECT
    group_name,
    COUNT(user_id) AS user_count,
    ROUND(SUM(is_clicked) / COUNT(*), 4) AS click_rate,
    ROUND(SUM(is_converted) / COUNT(*), 4) AS conversion_rate
FROM ab_test
GROUP BY group_name;

2. 点击用户中的转化率（排除未点击用户）
SELECT
    group_name,
    COUNT(user_id) AS clicked_user_count,
    ROUND(SUM(is_converted) / COUNT(*), 4) AS post_click_conversion_rate
FROM ab_test
WHERE is_clicked = 1
GROUP BY group_name;
