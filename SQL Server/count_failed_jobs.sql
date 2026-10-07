SELECT COUNT(*)
FROM fme_job_history
WHERE job_status IN (9, 10)
  AND date_finished >= DATEADD(MINUTE, -1, GETDATE());