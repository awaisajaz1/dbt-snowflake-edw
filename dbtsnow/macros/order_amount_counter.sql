{% macro order_calculation(x,y, operator) %}
    {% if operator == 'add' %}
        ({{ x }} + {{ y }})
    {% elif operator == 'subtract' %}
        ({{ x }} - {{ y }})
    {% elif operator == 'multiply' %}
        ({{ x }} * {{ y }})
    {% elif operator == 'divide' %}
        ({{ x }} / {{ y }})
    {% else %}
        ({{ x }} + {{ y }})
    {% endif %}
{% endmacro %}