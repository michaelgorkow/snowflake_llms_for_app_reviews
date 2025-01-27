USE ROLE ACCOUNTADMIN;
-- Create fresh database
USE SCHEMA APP_REVIEWS.PUBLIC;

-- Create demo notebooks
-- Emirates App
CREATE OR REPLACE NOTEBOOK APP_REVIEWS.PUBLIC.EMIRATES_APP_ANALYSIS 
FROM '@APP_REVIEWS.PUBLIC.GITHUB_REPO_SIMPLE_APP_REVIEWS/branches/main/' 
MAIN_FILE = 'emirates_app_analysis.ipynb' 
QUERY_WAREHOUSE = compute_wh
EXTERNAL_ACCESS_INTEGRATIONS=(GOOGLE_PLAYSTORE_INTEGRATION);
ALTER NOTEBOOK APP_REVIEWS.PUBLIC.EMIRATES_APP_ANALYSIS ADD LIVE VERSION FROM LAST;

-- ABB Apps
CREATE OR REPLACE NOTEBOOK APP_REVIEWS.PUBLIC.ABB_APP_ANALYSIS 
FROM '@APP_REVIEWS.PUBLIC.GITHUB_REPO_SIMPLE_APP_REVIEWS/branches/main/' 
MAIN_FILE = 'abb_app_analysis.ipynb' 
QUERY_WAREHOUSE = compute_wh
EXTERNAL_ACCESS_INTEGRATIONS=(GOOGLE_PLAYSTORE_INTEGRATION);
ALTER NOTEBOOK APP_REVIEWS.PUBLIC.ABB_APP_ANALYSIS ADD LIVE VERSION FROM LAST;