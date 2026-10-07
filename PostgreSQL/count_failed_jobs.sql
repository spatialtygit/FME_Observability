select count(*)
from fme_job_history
where job_status IN (9, 10)
and date_finished >= NOW() AT TIME ZONE 'America/Chicago' - INTERVAL '1 minute';  --Set Time zone for your region