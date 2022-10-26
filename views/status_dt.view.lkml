explore: status_dt {}

view: status_dt {
  derived_table: {
    datagroup_trigger: current
    # increment_key: "created_date"
    # explore_source: order_items {
    #   column: created_date {}
    #   column: status {}
    #   column: benchmark_total_sales_amount {}
    # }
    sql:
    SELECT
    (DATE(order_items.created_at )) AS created_date,
    order_items.status  AS status,
    COALESCE(SUM(order_items.sale_price ), 0) AS total_sales_amount
    FROM `lookerplus.the_look.order_items` AS order_items
    LEFT JOIN `lookerplus.the_look.users`
    AS users ON order_items.user_id = users.id
    GROUP BY
    1,
    2
    ORDER BY
    3 DESC
    ;;
  }
  dimension: created_date {
    type: date
  }

  dimension: status {}

  dimension: sales_amount {
    hidden: yes
    type: number
    sql: ${TABLE}.total_sales_amount ;;
  }

  measure: total_sales_amount {
    type: sum
    sql: ${sales_amount} ;;
    value_format_name: usd
  }
}

explore: numbers {}
view: numbers {
  derived_table: {
    sql:
    SELECT 34 as number
    UNION ALL
    SELECT 3400 as number
    UNION ALL
    SELECT 349090 as number
    UNION ALL
    SELECT 3478909 as number
    UNION ALL
    SELECT 3478907890 as number
    UNION ALL
    SELECT 340689068906890 as number
    ;;
  }
  dimension: number_formatted {
    sql: ${number} ;;
    html:
    {% assign number = value | split: "" | reverse %}
    {% assign length = number.size | minus: 1 %}
    {% for i in (0..length) %}{{ number[i] }}{% assign mod3 = i|modulo:3 %}{% if mod3 == 2 %},{% endif %}{% endfor %}
    ;;
  }
  dimension: number_formatted2 {
    sql: ${number} ;;
    html:
    {% assign number = value | split: "" %}
    {% assign length = number.size | minus: 1 | at_most: 3 %}
    {% for i in (0..length) %}{{ number[i] }}{% if i == 0 %},{% endif %}{% endfor %}
    ;;
  }
  dimension: number {
    type: number
  }
  dimension: length {
    sql: ${number} ;;
    html: {% assign number = value | split: "" %}{{number.size}} ;;
  }
}
