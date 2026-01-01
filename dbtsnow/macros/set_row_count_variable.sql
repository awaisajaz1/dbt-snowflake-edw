{% macro set_row_count_variable(table_name, var_name, schema_name='bronze') %}
  {% set row_count = get_row_count(table_name, schema_name) %}
  
  {# Set the variable in the context #}
  {% do var.update({var_name: row_count}) %}
  
  {# Log the result #}
  {{ log("Table " ~ table_name ~ " has " ~ row_count ~ " rows. Variable '" ~ var_name ~ "' set to " ~ row_count, info=True) }}
  
  {{ return(row_count) }}
{% endmacro %}