--Create initial data science workload needs
USE ROLE SECURITYADMIN;
CREATE ROLE DATA_SCIENCE;
GRANT ROLE DATA_SCIENCE TO ROLE SYSADMIN;

--Create warehouse so that Data science team has independent compute resources to work with
USE ROLE SYSADMIN;
CREATE OR REPLACE WAREHOUSE DATA_SCIENCE 
WAREHOUSE_TYPE=STANDARD
WAREHOUSE_SIZE=XSMALL 
AUTO_RESUME=TRUE
AUTO_SUSPEND=60
INITIALLY_SUSPENDED=TRUE
MAX_CLUSTER_COUNT=3
;
--Grant Data science access to monitor and resize their warehouse themselves
GRANT ALL PRIVILEGES ON WAREHOUSE DATA_SCIENCE TO ROLE DATA_SCIENCE;

--Determine what Snowflake packages are available and what versions
select * from information_schema.packages where language = 'python' and package_name='prophet';

--Data setup
USE ROLE SYSADMIN;
CREATE DATABASE SNOWPARK;
CREATE SCHEMA FORECAST;
--Internal stage for uploading of files for testing, alternatively can write the table directly from Snowpark function
CREATE STAGE DATA_INTERNAL_STAGE;
--Upload files from data folder via Snowsight UI
--Create table
CREATE OR REPLACE TABLE SALES (
    SALE_DATE date,
    STORE varchar,
    item varchar,
    sale_amt number(38,2)
);

--Load Sales Data from internal stage
COPY INTO SALES (SALE_DATE, STORE, ITEM, SALE_AMT)
FROM @DATA_INTERNAL_STAGE/forecast/forecast_train.csv
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER=1);
select count(*) from sales;

--Run below after forecast_udf and forecast_udtf python code has been deployed within Snowflake
USE DATABASE SNOWPARK;
USE SCHEMA FORECAST;
USE WAREHOUSE DATA_SCIENCE;
-- Call Python Function Example
select value[1]::date d, value[0] prediction
from table(flatten(
  forecast(['2020-01-01', '2020-01-02'], [1, 2], 4)
));

--Table Function Example
WITH DATA AS (
    SELECT STORE, SALE_DATE, SUM(SALE_AMT) as AMT
    FROM SALES
    GROUP BY STORE, SALE_DATE
)

SELECT
FORECAST.*
FROM DATA,
TABLE(FORECAST_DAILY(STORE,CAST(AMT as FLOAT),SALE_DATE,360) OVER (PARTITION BY STORE)) FORECAST
WHERE FORECAST.ID IN ('1','1_lower','1_upper');
