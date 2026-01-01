{# -- Example: How to use the row count macros in a model

-- Method 1: Get row count and use it directly
{% set customer_count = get_row_count('customers', 'bronze') %}

-- Method 2: Set a variable with the row count
{% set orders_count = set_row_count_variable('orders', 'total_orders', 'bronze') %}

-- Method 3: Use in conditional logic
{% if get_row_count('products', 'bronze') > 0 %}
  -- Process products if table has data
  SELECT 
    'products' as table_name,
    {{ customer_count }} as customer_count,
    {{ orders_count }} as orders_count,
    'Table has data' as status
{% else %}
  -- Handle empty table
  SELECT 
    'products' as table_name,
    0 as customer_count,
    0 as orders_count,
    'Table is empty' as status
{% endif %}

-- Method 4: Use in WHERE clause for data validation
UNION ALL

SELECT 
  'validation' as table_name,
  {{ customer_count }} as customer_count,
  {{ orders_count }} as orders_count,
  CASE 
    WHEN {{ customer_count }} > 0 THEN 'Customers table populated'
    ELSE 'Customers table empty'
  END as status #}