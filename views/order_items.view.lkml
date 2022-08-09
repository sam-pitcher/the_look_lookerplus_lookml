include: "../views_common/period_over_period.view"

view: order_items {
  extends: [period_over_period]
  view_label: "Transaction Information"
  sql_table_name: `lookerplus.the_look.order_items`;;

  # Dates

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  # Period over Period Date Overide
  dimension_group: pop_no_tz {
    sql: ${created_date} ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.delivered_at ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.shipped_at ;;
  }

  # IDs

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  # Order Information

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
    html: {% if value == 'Shipped' %}samshipped
    {% endif %};;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  # Test

  dimension: test_for_pdt_build_dim {
    type: string
    sql: "{{ _user_attributes['test_for_pdt_build'] }}" ;;
  }

  # Measures

  # Order Count

  measure: number_one {
    type: sum
    sql: 1 ;;
  }

  measure: order_count {
    group_label: "My Measures"
    type: count_distinct
    sql: ${order_id} ;;
    filters: [products.is_my_brand: "Yes"]
  }

  measure: benchmark_order_count {
    group_label: "Benchmark Measures"
    type: count_distinct
    sql: ${order_id} ;;
  }

  # Order Item Count

  measure: order_item_count {
    group_label: "My Measures"
    type: count
    filters: [products.is_my_brand: "Yes"]
  }

  measure: benchmark_order_item_count {
    group_label: "Benchmark Measures"
    type: count
  }

  # Customer Count

  measure: customer_count {
    group_label: "My Measures"
    type: count_distinct
    sql: ${user_id} ;;
    filters: [products.is_my_brand: "Yes"]
  }

  measure: benchmark_customer_count {
    group_label: "Benchmark Measures"
    type: count_distinct
    sql: ${user_id} ;;
  }

  # Product Count

  measure: product_count {
    group_label: "My Measures"
    type: count_distinct
    sql: ${products.sku} ;;
    filters: [products.is_my_brand: "Yes"]
  }

  measure: benchmark_product_count {
    group_label: "Benchmark Measures"
    type: count_distinct
    sql: ${products.sku} ;;
  }

  # Total Sales Amount

  measure: total_sales_amount {
    group_label: "My Measures"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    filters: [products.is_my_brand: "Yes"]
  }

  measure: benchmark_total_sales_amount {
    group_label: "Benchmark Measures"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: total_sales_amount_previous_period {
    group_label: "My Measures"
    type: sum
    sql: ${sale_price} ;;
    filters: [products.is_my_brand: "Yes", period: "%Last%"]
  }

  measure: total_sales_amount_current_period {
    group_label: "My Measures"
    type: sum
    sql: ${sale_price} ;;
    filters: [products.is_my_brand: "Yes", period: "%This%"]
  }

  measure: benchmark_total_sales_amount_previous_period {
    group_label: "Benchmark Measures"
    type: sum
    sql: ${sale_price} ;;
    filters: [period: "%Last%"]
  }

  measure: benchmark_total_sales_amount_current_period {
    group_label: "Benchmark Measures"
    type: sum
    sql: ${sale_price} ;;
    filters: [period: "%This%"]
  }

  measure: last_order_date {
    type: max
    sql: ${created_date} ;;
  }

  measure: days_since_last_order {
    type: number
    sql: date_diff(current_date, ${last_order_date}, day) ;;
  }

}
