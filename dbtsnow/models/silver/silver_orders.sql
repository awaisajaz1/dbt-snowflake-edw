{{ config(
    materialized='incremental',
    unique_key='order_id',
    on_schema_change='fail'
) }}

SELECT
    order_id,
    customer_id,
    order_date,
    order_status,
    payment_method,
    payment_status,
    discount_amount,
    total_amount,
    {{ order_calculation('total_amount', 'discount_amount', 'add') }} as total_amount_before_discount,
    created_at,
    updated_at
FROM {{ ref('bronze_orders') }}
{% if is_incremental() %}
WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
{% endif %}