# FME Observability

SQL scripts for monitoring FME Flow job history and cluster health with ArcGIS Dashboards and ArcGIS Monitor.

**Looking for the walkthrough?** These scripts are the companion to our free course, [Keep your Data Flowing](https://spatialty.com/course/keep-your-data-flowing/). 
The course covers how the queries work, how to publish them as query layers, how to build the dashboard, and how to set up ArcGIS Monitor alerts. 
These scripts are much easier to use with the context the lessons provide.

## What's in this repo

**Dashboard views** (save these as views in the FME Flow database, then add them to ArcGIS Pro as query layers)

- `all_jobs_last_48_hours.sql`: combines running jobs with job history for the dashboard's chart, table, and indicators
- `fme_nodes.sql`: lists the cores and engines registered in the cluster

**ArcGIS Monitor queries** (each returns a single number, one observer per query)

- `count_failed_jobs.sql`: failed jobs in the last minute
- `count_queued_jobs.sql`: jobs currently waiting in the queue
- `count_fme_cores.sql`: cores registered in the cluster
- `count_fme_engines.sql`: engines registered in the cluster
- `count_remote_engines.sql`: remote engines registered in the cluster

Each query is provided for PostgreSQL and SQL Server.

## Before you run anything

These queries read directly from the FME Flow database. That is risky and probably not supported by Safe Software, so:

- Use a separate read-only account wherever possible
- Never edit the FME Flow tables
- Some queries need to be saved as views, so you'll need create-view permissions
- The table schema is not publicly documented and may change between FME Flow releases

## Tested with

| FME Flow | Database | ArcGIS Enterprise |
|----------|----------|-------------------|
| 2025.1 | PostgreSQL 16 | 11.5 |
| 2026.2 | SQL Server 2025 | 12.1 |

ArcGIS Monitor 2026.0 (database queries require Monitor 2026 or newer).

## Notes

- **Time zones:** FME Flow writes job timestamps without a time zone, so comparisons against the current time can quietly drift if your database session uses a different zone. The course covers how to handle this.
- **Machine names:** the example queries trim hostnames and domains from engine names. Adjust this to suit your environment.

## Questions or feedback

Share your dashboard on LinkedIn and tag @spatialty, or visit [spatialty.com](https://spatialty.com).