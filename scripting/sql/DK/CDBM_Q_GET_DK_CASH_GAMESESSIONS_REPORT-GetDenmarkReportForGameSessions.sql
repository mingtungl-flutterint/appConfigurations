-- DK end-of-day report by game session
-- GetDenmarkReportForGameSessions.sql
-- CDBM_Q_GET_DK_CASH_GAMESESSIONS_REPORT

-- start: 2025-06-15 20:00:00
--   end: 2025-06-16 19:59:59

WITH TEMP AS (
    SELECT currency, sessionid, SUM(BIGINT(totalbuyin)) AS SUM_totalbuyin, SUM(BIGINT(winnings)) AS SUM_winnings
    FROM USERGAMESESSIONS
    where finished between '${start}$' AND '${end}$'
    group by currency, sessionid
)
, TEMP2 AS (
    SELECT currency,s.sessionid ,SUM_totalbuyin, SUM_winnings,SUM(BIGINT(h.rake)) SUM_RAKE, count AS count_HANDS
    FROM TEMP s
    JOIN GAMESESSIONHANDS h ON (s.sessionid+s.SUM_totalbuyin-s.SUM_totalbuyin) = h.sessionid and h.potchips > 0
    GROUP BY currency, s.sessionid, SUM_totalbuyin, SUM_winnings
)
SELECT currency
    , SUM(SUM_totalbuyin) AS SUM_totalbuyin
    , SUM(SUM_winnings) AS SUM_winnings
    , SUM(SUM_RAKE) AS SUM_RAKE
    , SUM(count_HANDS ) AS count_HANDS
FROM TEMP2 GROUP BY currency
;
