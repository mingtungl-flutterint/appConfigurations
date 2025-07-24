-- DK: replicator-report-events.sql
select l.*
from db2admin.SAVEDREPORTSLOG_DK l
WHERE l.TIMEWHEN between '2021-05-13 14:48:00' and '2021-05-13 15:10:00' and l.TOKENID = '1722552' and l.fileseqnum between 18252 and 18278
;

select e.eventid,e.reportid,e.timewhen
        , l.reportid,l.fileuniqid,l.timewhen,l.tokenid,l.fileseqnum,l.flags
from db2admin.SAVEDREPORTEVENTS_DK e
join SAVEDREPORTSLOG_DK l on l.reportid = e.reportid
WHERE l.TIMEWHEN between '2021-05-13 14:48:00' and '2021-05-13 15:10:00' and l.TOKENID = '1722552' and l.fileseqnum between 18252 and 18278
--WHERE e.TIMEWHEN between '2021-05-13 14:48:00' and '2021-05-13 15:10:00'
;

select eventid,sourcedbmid,sourcedbmseqid,heartbeat,eventtype,eventrefid,eventtime,userintid,wheninserted,status
from db2admin.REPLICATORREPORTEVENTS_DK
      , l.reportid,l.fileuniqid,l.timewhen,l.tokenid,l.fileseqnum,l.flags
join SAVEDREPORTSLOG_DK l on l.reportid = r.reportid
WHERE l.TIMEWHEN between '2021-05-13 14:48:00' and '2021-05-13 15:10:00' and l.TOKENID = '1722552' and l.fileseqnum between 18252 and 18278
--WHERE eventtime between '2021-05-13 14:48:00' and '2021-05-13 15:10:00'
;

select l.reportid,l.fileuniqid,l.timewhen,l.tokenid,l.fileseqnum,l.flags, 'l' as log,
        e.eventid,e.reportid,e.timewhen, '|' as EV,
        r.eventid,r.sourcedbmid,r.sourcedbmseqid,r.heartbeat,r.eventtype,r.eventrefid,r.eventtime,r.userintid,r.wheninserted,r.status
from db2admin.SAVEDREPORTSLOG_DK l
join SAVEDREPORTEVENTS_DK e on l.reportid = e.reportid
join REPLICATORREPORTEVENTS_DK r on r.eventid = e.eventid
--WHERE l.TIMEWHEN between '2021-05-13 14:48:00' and '2021-05-13 15:10:00' and l.TOKENID = '1722552' and l.fileseqnum between 18252 and 18278
WHERE l.TOKENID='1722552' and l.fileseqnum in (18252, 18256)
;

select r.* --r.eventid,r.sourcedbmid,r.sourcedbmseqid,r.heartbeat,r.eventtype,r.eventrefid,r.eventtime,r.userintid,r.wheninserted,r.status
from db2admin.REPLICATORREPORTEVENTS_DK r
join SAVEDREPORTEVENTS_DK e on r.eventid = e.eventid
join SAVEDREPORTSLOG_DK l on l.reportid = e.reportid
WHERE l.TOKENID='1722552' and l.fileseqnum=18252
;