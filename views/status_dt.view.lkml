explore: status_dt {}

view: status_dt {
  derived_table: {
    datagroup_trigger: current
    increment_key: "created_date"
    # explore_source: order_items {
    #   column: created_date {}
    #   column: status {}
    #   column: benchmark_total_sales_amount {}
    # }
    sql:
    SELECT
    '@{env}' as env,
    (DATE(order_items.created_at )) AS created_date,
    order_items.status  AS status,
    COALESCE(SUM(order_items.sale_price ), 0) AS total_sales_amount
    FROM `lookerplus.the_look.order_items` AS order_items
    LEFT JOIN `lookerplus.the_look.users`
     AS users ON order_items.user_id = users.id
    GROUP BY
    1,
    2,
    3
    ORDER BY
    4 DESC
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
