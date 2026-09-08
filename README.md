# Snowflake End-to-End Data Pipeline Lab

A hands-on Snowflake pipeline covering the full path from raw files to
cost-optimized queries: **S3 → Stage → Load (COPY INTO / Snowpipe) →
Query semi-structured data → Warehouse & cost optimization**.

Built as interview preparation for Snowflake-focused data engineering roles.
Every SQL file is runnable end to end against a Snowflake trial account.

## Architecture

```
   S3 bucket
   Raw CSV and NDJSON files
          |
          v
   Stage
   External (S3) or internal
          |
          v
   Load
   COPY INTO or Snowpipe
          |
          v
   Query
   VARIANT dot notation, FLATTEN
          |
          v
   Optimize
   Warehouse size, resource monitors
```

Two ingestion paths are supported and both are included in `sql/02_stage.sql`:

- **Path A — External S3 stage**: uses a Snowflake storage integration
  tied to an AWS IAM role (no hardcoded credentials). This is the
  production-grade pattern.
- **Path B — Internal stage**: no AWS account required. Files are uploaded
  directly to Snowflake-managed storage via Snowsight or SnowSQL. Useful
  for practicing the Snowflake-side SQL without AWS console overhead.

## Project structure

```
.
├── data/
│   ├── orders.csv          # structured sample data
│   └── events.json         # semi-structured NDJSON with nested fields
├── sql/
│   ├── 01_setup.sql        # database, schema, warehouse
│   ├── 02_stage.sql        # S3 storage integration + internal stage
│   ├── 03_load.sql         # file formats, tables, COPY INTO
│   ├── 04_snowpipe.sql     # continuous ingestion via Snowpipe
│   ├── 05_query_semi_structured.sql   # VARIANT, LATERAL FLATTEN
│   └── 06_optimize.sql     # warehouse sizing, resource monitors
└── README.md
```

## Getting started

1. Run `sql/01_setup.sql` to create the database, schema, and warehouse.
2. Run `sql/02_stage.sql`. If you don't have an S3 bucket handy, skip to
   the "Path B" section in that file and use an internal stage instead.
3. For Path B, upload `data/orders.csv` and `data/events.json` via
   Snowsight (**Data → Databases → your DB → Stages → + Files**) or:
   ```
   PUT file://data/orders.csv @INTERNAL_LAB_STAGE AUTO_COMPRESS=TRUE;
   PUT file://data/events.json @INTERNAL_LAB_STAGE AUTO_COMPRESS=TRUE;
   ```
4. Run `sql/03_load.sql` through `sql/06_optimize.sql` in order.

## Key concepts demonstrated

- **Storage integrations vs. hardcoded AWS keys** — why the integration
  pattern is the security-conscious default for external stages.
- **COPY INTO idempotency** — Snowflake tracks loaded files by metadata
  for 64 days, so re-running a load is a safe no-op.
- **COPY INTO vs. Snowpipe** — user-triggered batch load on your own
  warehouse vs. event-triggered load on Snowflake-managed compute,
  billed per-second.
- **Semi-structured data** — VARIANT columns, case-sensitive dot-notation
  paths, and `LATERAL FLATTEN` for nested arrays.
- **Cost and performance tuning** — reading `QUEUED_OVERLOAD_TIME` vs.
  `EXECUTION_TIME` to decide between a bigger warehouse (scale up) and a
  multi-cluster warehouse (scale out); auto-suspend trade-offs; resource
  monitors as a hard spending ceiling.

## Notes

Some SQL contains placeholder values (`<account_id>`, `<your_role>`,
`<your-bucket>`) that need to be filled in with your own AWS/Snowflake
details before running Path A.

## License

MIT
