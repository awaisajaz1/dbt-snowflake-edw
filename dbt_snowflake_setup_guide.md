# Complete dbt + Snowflake Setup Guide

## Prerequisites

Before starting, ensure you have:
- Python 3.8 or higher installed
- Git installed
- A Snowflake account with appropriate permissions
- pip package manager

## Step 1: Environment Setup

### Create Virtual Environment
```bash
python -m venv venv
source venv/bin/activate  # On macOS/Linux
# or
venv\Scripts\activate     # On Windows
```

### Install Required Libraries
```bash
pip install -r requirements.txt
```

The key libraries you need:
- **dbt-core**: The core dbt functionality
- **dbt-snowflake**: Snowflake adapter for dbt
- **sqlfluff**: SQL linting and formatting (optional but recommended)
- **dbt-checkpoint**: Pre-commit hooks for dbt (optional)

## Step 2: Snowflake Setup

### Create Database and Warehouse in Snowflake
Run these commands in your Snowflake worksheet:

```sql
-- Set up variabless
SET DATABASE_NAME = UPPER('DBT_DEMO');
SET WAREHOUSE_NAME = UPPER('COMPUTE_WH');

-- Create database
CREATE DATABASE IF NOT EXISTS IDENTIFIER($DATABASE_NAME);

-- Create warehouse
CREATE WAREHOUSE IF NOT EXISTS IDENTIFIER($WAREHOUSE_NAME)
  WITH WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE;

-- Create schemas
USE DATABASE IDENTIFIER($DATABASE_NAME);
CREATE SCHEMA IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS STAGING;
CREATE SCHEMA IF NOT EXISTS MARTS;
```

### Create dbt User (Optional but Recommended)
```sql
-- Create role for dbt
CREATE ROLE IF NOT EXISTS DBT_ROLE;

-- Create user for dbt
CREATE USER IF NOT EXISTS DBT_USER
  PASSWORD = 'your_secure_password'
  DEFAULT_ROLE = DBT_ROLE
  DEFAULT_WAREHOUSE = COMPUTE_WH;

-- Grant permissions
GRANT ROLE DBT_ROLE TO USER DBT_USER;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE DBT_ROLE;
GRANT ALL ON DATABASE DBT_DEMO TO ROLE DBT_ROLE;
GRANT ALL ON ALL SCHEMAS IN DATABASE DBT_DEMO TO ROLE DBT_ROLE;
GRANT ALL ON FUTURE SCHEMAS IN DATABASE DBT_DEMO TO ROLE DBT_ROLE;
GRANT ALL ON ALL TABLES IN DATABASE DBT_DEMO TO ROLE DBT_ROLE;
GRANT ALL ON FUTURE TABLES IN DATABASE DBT_DEMO TO ROLE DBT_ROLE;
```

## Step 3: Initialize dbt Project

### Create New dbt Project
```bash
dbt init my_dbt_project
cd my_dbt_project
```

During initialization, you'll be prompted to:
1. Choose Snowflake as your database
2. Enter your Snowflake connection details

## Step 4: Configure profiles.yml

Create or edit `~/.dbt/profiles.yml`:

```yaml
my_dbt_project:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: your_account.region.cloud  # e.g., abc123.us-west-2.aws
      user: your_username
      password: your_password
      role: your_role
      database: DBT_DEMO
      warehouse: COMPUTE_WH
      schema: staging
      threads: 4
      client_session_keep_alive: false
      query_tag: dbt
    
    prod:
      type: snowflake
      account: your_account.region.cloud
      user: your_username
      password: your_password
      role: your_role
      database: DBT_DEMO
      warehouse: COMPUTE_WH
      schema: marts
      threads: 4
      client_session_keep_alive: false
      query_tag: dbt_prod
```

### Alternative Authentication Methods

#### Key Pair Authentication
```yaml
my_dbt_project:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: your_account.region.cloud
      user: your_username
      private_key_path: /path/to/private_key.pem
      private_key_passphrase: your_passphrase  # if encrypted
      role: your_role
      database: DBT_DEMO
      warehouse: COMPUTE_WH
      schema: staging
      threads: 4
```

## Step 5: Test Connection

```bash
dbt debug
```

This command will:
- Check your dbt installation
- Validate your profiles.yml configuration
- Test connection to Snowflake

## Step 6: Project Structure

Your dbt project structure should look like:

```
my_dbt_project/
├── dbt_project.yml
├── profiles.yml (optional, can be in ~/.dbt/)
├── models/
│   ├── staging/
│   ├── marts/
│   └── schema.yml
├── macros/
├── tests/
├── snapshots/
├── seeds/
└── analyses/
```

## Step 7: Configure dbt_project.yml

Edit your `dbt_project.yml`:

```yaml
name: 'my_dbt_project'
version: '1.0.0'
config-version: 2

profile: 'my_dbt_project'

model-paths: ["models"]
analysis-paths: ["analyses"]
test-paths: ["tests"]
seed-paths: ["seeds"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]

clean-targets:
  - "target"
  - "dbt_packages"

models:
  my_dbt_project:
    staging:
      +materialized: view
      +schema: staging
    marts:
      +materialized: table
      +schema: marts

vars:
  # Define global variables here
  start_date: '2024-01-01'
```

## Step 8: Create Your First Model

Create `models/staging/stg_customers.sql`:

```sql
{{ config(materialized='view') }}

select
    customer_id,
    customer_name,
    email,
    created_at,
    updated_at
from {{ source('raw', 'customers') }}
where customer_id is not null
```

Create `models/schema.yml`:

```yaml
version: 2

sources:
  - name: raw
    description: Raw data from source systems
    tables:
      - name: customers
        description: Customer data
        columns:
          - name: customer_id
            description: Unique customer identifier
            tests:
              - unique
              - not_null

models:
  - name: stg_customers
    description: Staged customer data
    columns:
      - name: customer_id
        description: Unique customer identifier
        tests:
          - unique
          - not_null
```

## Step 9: Run Your First dbt Commands

```bash
# Install packages (if any)
dbt deps

# Run models
dbt run

# Run tests
dbt test

# Generate documentation
dbt docs generate
dbt docs serve
```

## Step 10: Best Practices

### Environment Variables
Create a `.env` file for sensitive information:

```bash
DBT_SNOWFLAKE_ACCOUNT=your_account.region.cloud
DBT_SNOWFLAKE_USER=your_username
DBT_SNOWFLAKE_PASSWORD=your_password
DBT_SNOWFLAKE_ROLE=your_role
DBT_SNOWFLAKE_WAREHOUSE=COMPUTE_WH
DBT_SNOWFLAKE_DATABASE=DBT_DEMO
```

### Git Integration
```bash
git init
git add .
git commit -m "Initial dbt project setup"
```

### Recommended Packages
Add to `packages.yml`:

```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.1.1
  - package: calogica/dbt_expectations
    version: 0.10.1
  - package: dbt-labs/audit_helper
    version: 0.9.0
```

## Troubleshooting

### Common Issues:

1. **Connection timeout**: Increase `connect_timeout` in profiles.yml
2. **MFA prompts**: Enable MFA token caching in Snowflake
3. **Permission errors**: Ensure proper grants are in place
4. **Account identifier**: Use correct format for your region/cloud

### Useful Commands:
```bash
# Check dbt version
dbt --version

# Compile models without running
dbt compile

# Run specific model
dbt run --select stg_customers

# Run models with full refresh
dbt run --full-refresh
```

This setup gives you a solid foundation for building your data warehouse with dbt and Snowflake! 