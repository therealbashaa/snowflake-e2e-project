-- ============================================================
-- PATH A: External S3 stage via storage integration (preferred pattern)
-- ============================================================
CREATE OR REPLACE STORAGE INTEGRATION S3_LAB_INT
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::<account_id>:role/<your_role>'
  STORAGE_ALLOWED_LOCATIONS = ('s3://<your-bucket>/lab/');

DESC INTEGRATION S3_LAB_INT;
-- Copy STORAGE_AWS_IAM_USER_ARN and STORAGE_AWS_EXTERNAL_ID into the
-- AWS IAM role's trust policy before continuing.

CREATE OR REPLACE STAGE S3_LAB_STAGE
  STORAGE_INTEGRATION = S3_LAB_INT
  URL = 's3://<your-bucket>/lab/'
  FILE_FORMAT = (TYPE = 'CSV');

LIST @S3_LAB_STAGE;

-- ============================================================
-- PATH B: Internal stage (no AWS required)
-- ============================================================
CREATE OR REPLACE STAGE INTERNAL_LAB_STAGE;

-- Upload via SnowSQL:
-- PUT file://data/orders.csv @INTERNAL_LAB_STAGE AUTO_COMPRESS=TRUE;
-- PUT file://data/events.json @INTERNAL_LAB_STAGE AUTO_COMPRESS=TRUE;
-- Or upload via Snowsight: Data > Databases > ECOMM_LAB > RAW > Stages > INTERNAL_LAB_STAGE > + Files

LIST @INTERNAL_LAB_STAGE;
