{% macro get_row_count(table_name, schema_name='bronze') %}
  {% set query %}
    SELECT COUNT(*) as row_count 
    FROM {{ target.database }}.{{ schema_name }}.{{ table_name }}
  {% endset %}
  
  {% set results = run_query(query) %}
  
  {% if execute %}
    {% set row_count = results.columns[0].values()[0] %}
    {{ return(row_count) }}
  {% else %}
    {{ return(0) }}
  {% endif %}
{% endmacro %}