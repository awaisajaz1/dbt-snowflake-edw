{% set cols = ['CUSTOMER_ID', 'PHONE'] %}



select
{% for col in cols %}
    {{ col }}{% if not loop.last %},{% endif %}
{% endfor %}
from
    {{ ref('silver_customers') }}

-- another way of doing the interation
-- select
--    {{ cols | join(', ') }}
--from
--    {{ ref('silver_customers') }}
