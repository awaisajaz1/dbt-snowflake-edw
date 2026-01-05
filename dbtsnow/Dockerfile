# Use the official dbt-snowflake image
FROM ghcr.io/dbt-labs/dbt-snowflake:1.7.0

# Set working directory
WORKDIR /usr/app/dbt

# Copy the dbt project files into the container
COPY . .

# Install dbt dependencies (Uncomment if you add a packages.yml file)
# RUN dbt deps

# Set environment variables for dbt
ENV DBT_PROFILES_DIR=.

# Default command to run when the container starts
CMD ["dbt", "build"]
