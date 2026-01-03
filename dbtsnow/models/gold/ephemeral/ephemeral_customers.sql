{{ config(materialized='ephemeral') }}


select 
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    customer_status,
    updated_at
from {{ ref('bronze_customers') }}
