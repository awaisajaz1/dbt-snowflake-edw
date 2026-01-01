
{% set state = "CA" %}

select * from {{ ref('silver_customers') }}
where state = '{{ state }}'