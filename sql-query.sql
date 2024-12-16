WITH GroupedDays AS (
    SELECT 
        day, 
        CASE 
            WHEN value >= 0 THEN 'positive' 
            ELSE 'negative' 
        END AS trend,
        SUM(
            CASE 
                WHEN LAG(CASE WHEN value >= 0 THEN 'positive' ELSE 'negative' END) 
                     OVER (ORDER BY day) = 
                     CASE WHEN value >= 0 THEN 'positive' ELSE 'negative' END 
                THEN 0 
                ELSE 1 
            END
        ) OVER (ORDER BY day) AS group_id
    FROM stock_days
),

SequenceLengths AS (
    SELECT 
        trend, 
        group_id, 
        COUNT(*) AS length
    FROM GroupedDays
    GROUP BY trend, group_id
)

SELECT 
    trend, 
    length, 
    COUNT(*) AS sequence_count
FROM SequenceLengths
GROUP BY trend, length
ORDER BY trend, length;
