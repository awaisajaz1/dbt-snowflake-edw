    {% set configs = 
    [
        {
            "table": "silver.silver_orders",
            "columns": "silver_orders.order_id, silver_orders.order_date, silver_orders.customer_id, silver_orders.total_amount",
            "alias": "silver_orders"
        },
        {
            "table": "silver.silver_customers",
            "columns": "silver_customers.customer_id as cust_id, silver_customers.first_name, silver_customers.email, silver_customers.phone, silver_customers.customer_status",
            "alias": "silver_customers",
            "join_condition": "silver_orders.customer_id = silver_customers.customer_id"
        },
        {
            "table": "silver.silver_suppliers",
            "columns": "silver_suppliers.supplier_id, silver_suppliers.supplier_name, silver_suppliers.email, silver_suppliers.phone, silver_suppliers.full_address",
            "alias": "silver_suppliers",
            "join_condition": "silver_orders.supplier_id = silver_suppliers.supplier_id"
        }
    ]
%}


select 
    {{ configs[0].columns }},
    {{ configs[1].columns }}
    -- {{ configs[2].columns }}
from 
    {{ configs[0].table }} as {{ configs[0].alias }}
    left join {{ configs[1].table }} as {{ configs[1].alias }} on {{ configs[1].join_condition }}
    -- left join {{ configs[2].table }} as {{ configs[2].alias }} on {{ configs[2].join_condition }} 