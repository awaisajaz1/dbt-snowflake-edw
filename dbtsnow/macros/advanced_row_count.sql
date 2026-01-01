{% macro get_table_stats(table_name, schema_name='bronze') %}
  {% set query %}
    SELECT 
      COUNT(*) as total_rows,
      COUNT(DISTINCT customer_id) as unique_customers,
      MIN(created_at) as earliest_record,
      MAX(updated_at) as latest_record
    FROM {{ target.database }}.{{ schema_name }}.{{ table_name }}
  {% endset %}
  
  {% set results = run_query(query) %}
  
  {% if execute %}
    {% set stats = {
      'total_rows': results.columns[0].values()[0],
      'unique_customers': results.columns[1].values()[0],
      'earliest_record': results.columns[2].values()[0],
      'latest_record': results.columns[3].values()[0]
    } %}
    {{ return(stats) }}
  {% else %}
    {{ return({'total_rows': 0, 'unique_customers': 0, 'earliest_record': null, 'latest_record': null}) }}
  {% endif %}
{% endmacro %}

{% macro log_table_stats(table_name, schema_name='bronze') %}
  {% set stats = get_table_stats(table_name, schema_name) %}
  
  {{ log("=== TABLE STATISTICS ===", info=True) }}
  {{ log("Table: " ~ schema_name ~ "." ~ table_name, info=True) }}
  {{ log("Total Rows: " ~ stats.total_rows, info=True) }}
  {{ log("Unique Customers: " ~ stats.unique_customers, info=True) }}
  {{ log("Earliest Record: " ~ stats.earliest_record, info=True) }}
  {{ log("Latest Record: " ~ stats.latest_record, info=True) }}
  {{ log("========================", info=True) }}
  
  {{ return(stats) }}
{% endmacro %}