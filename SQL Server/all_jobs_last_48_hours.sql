SELECT top 1000000 *
FROM (SELECT jh.job_id,
             jh.date_queued,
             jh.date_started,
             jh.date_finished,
             CAST(jh.elapsedtime / 1000 AS int) AS runtime,
             jh.tag,
             jh.repository_name,
             jh.workspace_name,
             jh.engine_instance,
             js.job_status                         AS status,
             CASE
              WHEN date_started IS NULL AND date_finished IS NULL THEN 1 -- queued
              WHEN date_started IS NOT NULL AND date_finished IS NULL THEN 2 -- running
              ELSE 3 -- canceled, finished, etc
             END AS sorder,
             ua.username
      FROM dbo.fme_job_history AS jh
               INNER JOIN dbo.fme_job_status AS js
                          ON jh.job_status = js.id
               INNER JOIN dbo.fme_useraccount AS ua
                          ON jh.useraccount_id = ua.useraccount_id
      WHERE jh.date_finished >= DATEADD(HOUR, -48, GETDATE())

      UNION ALL

      SELECT j.job_id,
             j.date_queued,
             j.date_started,
             j.date_finished,
             CAST(j.elapsedtime / 1000 AS int) AS runtime,
             j.tag,
             j.repository_name,
             j.workspace_name,
             j.engine_instance,
             js.job_status                        AS status,
             CASE
              WHEN date_started IS NULL AND date_finished IS NULL THEN 1 -- queued
              WHEN date_started IS NOT NULL AND date_finished IS NULL THEN 2 -- running
              ELSE 3 -- canceled, finished, etc
             END AS sorder,
             ua.username
      FROM dbo.fme_jobs AS j
               INNER JOIN dbo.fme_job_status AS js
                          ON j.job_status = js.id
               INNER JOIN dbo.fme_useraccount AS ua
                          ON j.useraccount_id = ua.useraccount_id) AS all_jobs
                          ORDER BY sorder, date_queued DESC;