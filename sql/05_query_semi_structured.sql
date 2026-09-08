-- Note: VARIANT path keys are case-sensitive and must match the JSON exactly (lowercase here)

SELECT
  raw_json:event_id::STRING            AS event_id,
  raw_json:customer_id::STRING         AS customer_id,
  raw_json:event_type::STRING          AS event_type,
  raw_json:payload:device:type::STRING AS device_type,
  raw_json:payload:device:os::STRING   AS os
FROM EVENTS_RAW;

-- FLATTEN an array field (tags) -- one output row per tag
SELECT
  r.raw_json:event_id::STRING AS event_id,
  t.value::STRING              AS tag
FROM EVENTS_RAW r,
LATERAL FLATTEN(input => r.raw_json:payload:tags) t;

-- Join structured ORDERS with semi-structured purchase events
SELECT
  o.order_id,
  o.customer_id,
  o.amount,
  e.raw_json:event_type::STRING AS event_type
FROM ORDERS o
JOIN EVENTS_RAW e
  ON o.order_id::STRING = e.raw_json:payload:order_id::STRING
WHERE e.raw_json:event_type::STRING = 'purchase';

-- Materialized flat view -- cheaper than re-parsing VARIANT on every query
CREATE OR REPLACE VIEW EVENTS_FLAT AS
SELECT
  raw_json:event_id::STRING            AS event_id,
  raw_json:customer_id::STRING         AS customer_id,
  raw_json:event_type::STRING          AS event_type,
  raw_json:payload:device:type::STRING AS device_type,
  raw_json:payload:device:os::STRING   AS os
FROM EVENTS_RAW;
