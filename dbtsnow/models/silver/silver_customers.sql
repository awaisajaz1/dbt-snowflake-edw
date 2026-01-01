{{ config(
    materialized='incremental',
    unique_key='customer_id',
    on_schema_change='fail'
) }}

WITH source_data AS (
    SELECT 
        customer_id,
        first_name,
        last_name,
        email,
        phone,
        address,
        city,
        state,
        zip_code,
        country,
        registration_date,
        last_login_date,
        customer_status,
        created_at,
        updated_at,
        -- Add data quality flags
        CASE 
            WHEN email IS NULL OR email = '' THEN FALSE
            WHEN email NOT LIKE '%@%' THEN FALSE
            ELSE TRUE
        END AS is_valid_email,
        
        CASE 
            WHEN customer_status IN ('active', 'inactive', 'suspended') THEN TRUE
            ELSE FALSE
        END AS is_valid_status,
        
        -- Create full name
        CONCAT(first_name, ' ', last_name) AS full_name,
        
        -- Current timestamp for tracking
        CURRENT_TIMESTAMP() AS dbt_updated_at
        
    FROM {{ source('raw', 'customers') }}
    
    {% if is_incremental() %}
        -- Only process records that are new or updated
        WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
    {% endif %}
)

SELECT * FROM source_data