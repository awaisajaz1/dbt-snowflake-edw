{{ config(
    materialized='incremental',
    unique_key='product_id',
    on_schema_change='fail'
) }}

WITH source_data AS (
    SELECT 
        product_id,
        product_name,
        category,
        subcategory,
        brand,
        price,
        cost,
        weight_kg,
        dimensions,
        color,
        size,
        stock_quantity,
        supplier_id,
        is_active,
        created_at,
        updated_at,
        
        -- Add calculated fields
        ROUND(price - cost, 2) AS profit_margin,
        ROUND(((price - cost) / NULLIF(price, 0)) * 100, 2) AS profit_margin_percentage,
        
        -- Data quality flags
        CASE 
            WHEN price <= 0 THEN FALSE
            WHEN cost < 0 THEN FALSE
            ELSE TRUE
        END AS is_valid_pricing,
        
        CASE 
            WHEN stock_quantity < 0 THEN FALSE
            ELSE TRUE
        END AS is_valid_stock,
        
        -- Categorize by price range
        CASE 
            WHEN price < 25 THEN 'Budget'
            WHEN price BETWEEN 25 AND 75 THEN 'Mid-Range'
            WHEN price > 75 THEN 'Premium'
            ELSE 'Unknown'
        END AS price_category,
        
        -- Current timestamp for tracking
        CURRENT_TIMESTAMP() AS dbt_updated_at
        
    FROM {{ source('raw', 'products') }}
    
    {% if is_incremental() %}
        -- Only process records that are new or updated
        WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
    {% endif %}
)

SELECT * FROM source_data