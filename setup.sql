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

-- Create demo notebooks
CREATE OR REPLACE NOTEBOOK SIMPLE_ML_DB.PUBLIC.EMIRATES_APP_ANALYSIS 
FROM '@APP_REVIEWS.PUBLIC.GITHUB_REPO_SIMPLE_APP_REVIEWS/branches/main/' 
MAIN_FILE = 'emirates_app_analysis.ipynb' 
QUERY_WAREHOUSE = compute_wh
EXTERNAL_ACCESS_INTEGRATIONS=(GOOGLE_PLAYSTORE_INTEGRATION);
ALTER NOTEBOOK SIMPLE_ML_DB.PUBLIC.EMIRATES_APP_ANALYSIS ADD LIVE VERSION FROM LAST;
