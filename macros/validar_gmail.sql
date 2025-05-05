{% macro validar_gmail(email_column) %}
  coalesce(
        regexp_like({{ email_column }}, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$') = true,false
    )
{% endmacro %}