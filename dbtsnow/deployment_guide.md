# Docker Deployment Guide for dbt Project

This guide outlines the steps to containerize your dbt project (`dbtsnow`) and deploy it using Docker.

## 1. Dockerfile

Create a file named `Dockerfile` in the root of your dbt project directory. This file defines the environment for your dbt project.

We recommend using the official dbt-snowflake image.

```dockerfile
# Use the official dbt-snowflake image
# Check https://hub.docker.com/r/dbt-labs/dbt-snowflake/tags for specific versions if needed
FROM ghcr.io/dbt-labs/dbt-snowflake:1.7.0

# Set working directory
WORKDIR /usr/app/dbt

# Copy the dbt project files into the container
COPY . .

# Install dbt dependencies (if packages.yml exists)
RUN dbt deps

# Set environment variables for dbt
ENV DBT_PROFILES_DIR=.

# Default command to run when the container starts
# "dbt build" runs snapshots, models, seeds, and tests in the correct order
CMD ["dbt", "build"]
```

## 2. Profiles Configuration (`profiles.yml`)

For Docker deployments, it is best practice to handle credentials using Environment Variables rather than hardcoding them.

Ensure your `profiles.yml` (usually in your root directory for Docker setup as configured above) looks like this:

```yaml
dbtsnow:
  target: prod
  outputs:
    prod:
      type: snowflake
      account: "{{ env_var('DBT_SNOWFLAKE_ACCOUNT') }}"
      user: "{{ env_var('DBT_SNOWFLAKE_USER') }}"
      password: "{{ env_var('DBT_SNOWFLAKE_PASSWORD') }}"
      role: "{{ env_var('DBT_SNOWFLAKE_ROLE') }}"
      database: "{{ env_var('DBT_SNOWFLAKE_DATABASE') }}"
      warehouse: "{{ env_var('DBT_SNOWFLAKE_WAREHOUSE') }}"
      schema: "{{ env_var('DBT_SNOWFLAKE_SCHEMA') }}"
      threads: 4
      client_session_keep_alive: False
```

## 3. Building the Docker Image

Run the following command in your terminal from the project root to build the Docker image:

```bash
docker build -t dbtsnow-project .
```

## 4. Running the Container

To trigger the dbt pipeline (running all models and snapshots), use the `docker run` command. You will need to pass in your credentials as environment variables.

### The Execution Command

```bash
docker run \
  -e DBT_SNOWFLAKE_ACCOUNT=your_account_id \
  -e DBT_SNOWFLAKE_USER=your_username \
  -e DBT_SNOWFLAKE_PASSWORD=your_password \
  -e DBT_SNOWFLAKE_ROLE=your_role \
  -e DBT_SNOWFLAKE_DATABASE=your_database \
  -e DBT_SNOWFLAKE_WAREHOUSE=your_warehouse \
  -e DBT_SNOWFLAKE_SCHEMA=your_schema \
  dbtsnow-project
```

### Explanation of the Command
The `CMD ["dbt", "build"]` instruction in the Dockerfile tells the container to execute `dbt build` by default.

*   **`dbt build`**: This is the modern, recommended command. It executes:
    1.  **Snapshots**: Captures data state.
    2.  **Seeds**: Loads CSVs.
    3.  **Models**: Runs your SQL transformations (View/Table/Incremental).
    4.  **Tests**: Runs schema and data tests.
    
    It runs them in the exact dependency order defined in your DAG (Directed Acyclic Graph).

## 5. Overriding the Command

If you need to run a specific task (e.g., only snapshots) without changing the Dockerfile, you can override the command at runtime:

```bash
# Only run snapshots
docker run [env_vars...] dbtsnow-project dbt snapshot

# Only run specific models
docker run [env_vars...] dbtsnow-project dbt build --select +fact_orders
```
