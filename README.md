# Data Science Flow with Snowpark Python
This repository contains the code for create a forecast using Meta's Prophet python library

# Pre-requisites
1. VSCode Installed w/ Python extension
2. Anaconda installed - https://docs.anaconda.com/free/anaconda/install/index.html
3. Snowflake extension installed within VSCode
4. Jupyter extension installed within VSCode
5. SnowSQL installed - https://docs.snowflake.com/en/user-guide/snowsql-install-config
6. SnowSQL credentials configured within ~/.snowsql/config
7. utils/snowpark_utils.py `connection_name` modified to reference respective SnowSQL config profile

# Create Anaconda Environment
1. conda env create -f conda_env.yml
2. conda activate pysnowpark38
3. Update VSCode Python default interpreter to be /Users/[user]/anaconda3/envs/pysnowpark38

# Deploy functions leveraging Snowflake CLI (https://github.com/Snowflake-Labs/snowcli)
1. Navigate to function folder
2. Ensure you have an app.toml configuration file and requirements.txt
3. Run `snow function create`

Credit for this code goes to Andrew Evans of phData.