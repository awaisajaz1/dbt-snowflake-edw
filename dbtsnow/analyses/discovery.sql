-- depends_on: {{ ref('silver_customers') }}


{% set state = "CA" %}
{% set customer_count = get_row_count('bronze_customers', 'bronze') %}



{% if customer_count > 0 %}
    select * from {{ ref('silver_customers') }}
    where state = '{{ state }}'
{% else %}
    select 'No Customer found!' as message
{% endif %}