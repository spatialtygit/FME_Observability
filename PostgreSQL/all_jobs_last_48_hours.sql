SELECT *
FROM (SELECT jh.job_id,
             jh.date_queued,
             jh.date_started,
             jh.date_finished,
             (jh.elapsedtime / 1000)::bigint AS runtime,
             jh.tag,
             jh.repository_name,
             jh.workspace_name,
             CASE --clean up the machine names
              WHEN jh.engine_instance LIKE '%.%'
                THEN split_part(jh.engine_instance, '.', 1)
              ELSE split_part(jh.engine_instance, '_', 1)
             END                              AS engine_instance,
             js.job_status                   AS status,
             CASE --Create a field to aid with sorting running and queued jobs.
              WHEN date_started IS NULL AND date_finished IS NULL THEN 1 -- queued
              WHEN date_started IS NOT NULL AND date_finished IS NULL THEN 2 -- running
              ELSE 3 -- canceled, finished, etc
             END                             AS sorder,
             ua.username
      FROM public.fme_job_history AS jh
               INNER JOIN public.fme_job_status AS js
                          ON jh.job_status = js.id
               INNER JOIN public.fme_useraccount AS ua
                          ON jh.useraccount_id = ua.useraccount_id
      WHERE jh.date_finished >= NOW() - INTERVAL '48 hours'

      UNION ALL

      SELECT j.job_id,
             j.date_queued,
             j.date_started,
             j.date_finished,
             (j.elapsedtime / 1000)::bigint AS runtime,
             j.tag,
             j.repository_name,
             j.workspace_name,
             CASE --clean up the machine names
              WHEN j.engine_instance LIKE '%.%'
                THEN split_part(j.engine_instance, '.', 1)
              ELSE split_part(j.engine_instance, '_', 1)
             END                             AS engine_instance,
             js.job_status                  AS status,
             CASE --Create a field to aid with sorting running and queued jobs.
              WHEN date_started IS NULL AND date_finished IS NULL THEN 1 -- queued
              WHEN date_started IS NOT NULL AND date_finished IS NULL THEN 2 -- running
              ELSE 3 -- canceled, finished, etc
             END                            AS sorder,
             ua.username
      FROM public.fme_jobs AS j
               INNER JOIN public.fme_job_status AS js
                          ON j.job_status = js.id
               INNER JOIN public.fme_useraccount AS ua
                          ON j.useraccount_id = ua.useraccount_id) AS all_jobs
ORDER BY sorder, date_queued DESC;