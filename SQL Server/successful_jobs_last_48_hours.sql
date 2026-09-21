-- Select Successful Jobs in the last 48 hours
SELECT job_id,
       date_queued,
       date_started,
       date_finished,
       CAST(elapsedtime / 1000 AS bigint) AS runtime,
       tag,
       repository_name,
       workspace_name,
       engine_instance,
       js.job_status                      AS status,
       ua.username
FROM dbo.fme_job_history jh
         INNER JOIN dbo.fme_job_status js
                    ON jh.job_status = js.id
         INNER JOIN dbo.fme_useraccount ua
                    ON jh.useraccount_id = ua.useraccount_id
                       AND date_finished >= DATEADD(HOUR, -48, GETDATE())
UNION
SELECT job_id,
       date_queued,
       date_started,
       date_finished,
       CAST(elapsedtime / 1000 AS bigint) AS runtime,
       tag,
       repository_name,
       workspace_name,
       engine_instance,
       js.job_status                      AS status,
       ua.username
FROM dbo.fme_jobs j
         INNER JOIN dbo.fme_job_status js
                    ON j.job_status = js.id
         INNER JOIN dbo.fme_useraccount ua
                    ON j.useraccount_id = ua.useraccount_id
ORDER BY date_queued, date_started, date_finished DESC;