    {% set configs = 
    [
        {
            "table": "silver.silver_orders",
            "columns": "silver_orders.order_id, silver_orders.order_date, silver_orders.customer_id, silver_orders.total_amount",
            "alias": "silver_orders"
        },
        {
            "table": "silver.silver_customers",
            "columns": "silver_customers.customer_id, silver_customers.first_name, silver_customers.email, silver_customers.phone, silver_customers.customer_status",
            "alias": "silver_customers",
            "join_condition": "silver_orders.customer_id = silver_customers.customer_id"
        }
    ]
%}


select 
    {% for config in configs %}
        {{ config.columns }} {% if not loop.last %},{% endif %}
    {% endfor %}
from
    {% for config in configs %}
        {% if loop.first %}
            {{ config.table }} as {{ config.alias }}
        {% else %}
            left join {{ config.table }} as {{ config.alias }} on {{ config.join_condition }}
        {% endif %}
    {% endfor %}