select count(*)
from fme_jobs
where job_status IN (1, 2, 3, 4);