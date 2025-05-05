{% macro validar_telefono(tlf) %}

CASE 
    WHEN LENGTH(REGEXP_REPLACE({{ tlf }}, '[^0-9]', '')) = 10 THEN
        REGEXP_REPLACE(
            REGEXP_REPLACE({{ tlf }}, '[^0-9]', ''),
            '(\\d{3})(\\d{3})(\\d{4})',
            '\\1-\\2-\\3'
        )
    ELSE 
        NULL
END

{% endmacro %}
