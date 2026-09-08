CREATE OR REPLACE PIPE EVENTS_PIPE
  AUTO_INGEST = TRUE
  AS
  COPY INTO EVENTS_RAW
  FROM @INTERNAL_LAB_STAGE
  FILE_FORMAT = (FORMAT_NAME = JSON_FF)
  PATTERN = '.*events.*[.]json.*';

SHOW PIPES;
SELECT SYSTEM$PIPE_STATUS('EVENTS_PIPE');

-- On an internal stage, trigger ingestion manually:
ALTER PIPE EVENTS_PIPE REFRESH;

-- Or trigger via REST API (insertFiles) using the snowflake-ingest Python SDK
-- -- see /docs/snowpipe_rest_api.md for the key-pair auth + Python client setup.

-- Snowpipe cost/latency visibility:
SELECT *
FROM SNOWFLAKE.ACCOUNT_USAGE.PIPE_USAGE_HISTORY
ORDER BY START_TIME DESC
LIMIT 20;
