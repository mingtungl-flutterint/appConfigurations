-- db2 -vtf C:\Users\mingtungl\sql\query.sql -z C:\Users\mingtungl\out\results.txt > null
-- SelectCashtransWithLoginDataForSpainStmt
--
SELECT    c.userintid
          ,c.transid, c.started, c.completed
          ,c.transtype, c.FXAMOUNT
          ,c.STATUS, c.auditid, c.parentid, c.purchaseId
          ,c.gateway, c.paysystem
          ,p.transtype AS parent_transtype
          ,p.auditid AS parent_auditid
          ,t.transId AS tr_transid
          ,t.transtype AS tr_transtype
          ,CASE when c.LOGINID64 = 0 and lastKnown.lastloginID is not null then lastKnown.lastloginID else c.LOGINID64 end AS lastloginID
FROM      cashtrans_root c
JOIN      userfirsttimeevents ufte ON (c.userintid=ufte.userintid AND ufte.licenseid=128 and ufte.when <= c.started)
LEFT JOIN cashtrans_root p ON (p.transid=c.parentid and c.parentid<>0)
JOIN      transacts t ON t.transid = (CASE WHEN c.auditid != 0 THEN c.auditid ELSE p.auditId END)
LEFT JOIN loggedoutapp loa ON loa.apploginid = c.apploginid AND loa.apptypeid = 8
LEFT JOIN loggedinapp lia ON lia.apploginid = c.apploginid AND lia.apptypeid = 8
LEFT JOIN logInData lastKnown on (c.userId = lastKnown.userId)
LEFT JOIN loggedin li ON li.loginid = lastloginID
LEFT JOIN loggedout lo ON lo.loginid = lastloginID

WHERE     c.FXAMOUNT != 0 and c.userintid in (51868056)
  and 	  ( ('2021-08-24 00:00:00' <= c.started and c.started < '2021-08-24 23:59:59') OR ('2021-08-24 00:00:00' <= c.completed and c.completed < '2021-08-24 23:59:59') )
order by  c.transid, c.started, c.completed
;

