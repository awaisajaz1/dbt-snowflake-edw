{{ config(
    materialized='incremental',
    unique_key='supplier_id',
    on_schema_change='fail'
) }}

WITH source_data AS (
    SELECT 
        supplier_id,
        supplier_name,
        contact_person,
        email,
        phone,
        address,
        city,
        state,
        zip_code,
        country,
        supplier_rating,
        is_active,
        created_at,
        updated_at,
        
        -- Add data quality flags
        CASE 
            WHEN email IS NULL OR email = '' THEN FALSE
            WHEN email NOT LIKE '%@%' THEN FALSE
            ELSE TRUE
        END AS is_valid_email,
        
        CASE 
            WHEN supplier_rating BETWEEN 0 AND 5 THEN TRUE
            ELSE FALSE
        END AS is_valid_rating,
        
        -- Categorize suppliers by rating
        CASE 
            WHEN supplier_rating >= 4.5 THEN 'Excellent'
            WHEN supplier_rating >= 4.0 THEN 'Good'
            WHEN supplier_rating >= 3.0 THEN 'Average'
            WHEN supplier_rating >= 2.0 THEN 'Below Average'
            ELSE 'Poor'
        END AS rating_category,
        
        -- Create full address
        CONCAT(address, ', ', city, ', ', state, ' ', zip_code, ', ', country) AS full_address,
        
        -- Current timestamp for tracking
        CURRENT_TIMESTAMP() AS dbt_updated_at
        
    FROM {{ source('raw', 'suppliers') }}
    
    {% if is_incremental() %}
        -- Only process records that are new or updated
        WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
    {% endif %}
)

SELECT * FROM source_data