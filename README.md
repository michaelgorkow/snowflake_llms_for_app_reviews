# Analyze App Reviews from Google Play Store Using Snowflake Cortex
This repo contains simple examples to retrieve app reviews from Google Playstore.  
Afterwards these reviews are analyzed using Snowpark Python and Snowflake Cortex LLMs.

## Requirements
* Snowflake Account

> [!IMPORTANT]
> External Access Integrations are currently not available for Trial Accounts!

## Get Started
Integrate this Github Repository with Snowflake by running the following SQL code in a Snowflake Worksheet:
```sql
USE ROLE ACCOUNTADMIN;
-- Create fresh database
CREATE OR REPLACE DATABASE APP_REVIEWS;
USE SCHEMA APP_REVIEWS.PUBLIC;

-- Create warehouse
CREATE WAREHOUSE IF NOT EXISTS COMPUTE_WH WITH WAREHOUSE_SIZE='X-SMALL';

-- Create Externa Access Integration to connect to Google Playstore
CREATE OR REPLACE NETWORK RULE GOOGLE_PLAYSTORE_RULE
MODE= 'EGRESS'
TYPE = 'HOST_PORT'
VALUE_LIST = ('play.google.com:443');

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION GOOGLE_PLAYSTORE_INTEGRATION
ALLOWED_NETWORK_RULES = (GOOGLE_PLAYSTORE_RULE)
ENABLED = true;

-- Create the integration with Github
CREATE OR REPLACE API INTEGRATION GITHUB_INTEGRATION_APP_REVIEWS
    api_provider = git_https_api
    api_allowed_prefixes = ('https://github.com/michaelgorkow/')
    enabled = true
    comment='Michaels repository containing all the awesome code.';

-- Create the integration with the Github repository
CREATE GIT REPOSITORY GITHUB_REPO_SIMPLE_APP_REVIEWS
	ORIGIN = 'https://github.com/michaelgorkow/snowflake_llms_for_app_reviews' 
	API_INTEGRATION = 'GITHUB_INTEGRATION_APP_REVIEWS' 
	COMMENT = 'Michaels repository containing all the awesome code.';

-- Fetch most recent files from Github repository
ALTER GIT REPOSITORY GITHUB_REPO_SIMPLE_APP_REVIEWS FETCH;
-- Create all demo notebooks
EXECUTE IMMEDIATE FROM @KAGGLE_TITANIC_CHALLENGE.PUBLIC.TITANIC_CHALLENGE_REPO/branches/main/setup/notebooks_setup.sql;
```

## Snowflake Features in this demo
* [Snowflake's Git Integration](https://docs.snowflake.com/en/developer-guide/git/git-overview)
* [Snowpark](https://docs.snowflake.com/en/developer-guide/snowpark/python/index)
* [Snowflake Cortex](https://docs.snowflake.com/en/user-guide/snowflake-cortex/llm-functions)

## API Documentation
* [Snowpark API](https://docs.snowflake.com/developer-guide/snowpark/reference/python/latest/snowpark/index)