include: "../views_common/period_over_period.view"

view: order_items_benchmark {
  extends: [period_over_period]
  view_label: "Transaction Information"
  sql_table_name: `looker-ps-emea-consultants.the_look_perf.order_items`;;

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
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension: product_category {
    type: string
    sql: ${TABLE}.product_category ;;
  }

  dimension: product_brand {
    type: string
    sql: ${TABLE}.product_brand ;;
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension: is_my_brand {
    type: yesno
    sql: ${product_brand} = 'Allegra K' ;;
  }

  # Customer Information

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  # Measures

  # Order Count

  measure: order_count {
    group_label: "My Measures"
    type: count_distinct
    sql: ${order_id} ;;
    filters: [is_my_brand: "Yes"]
  }

  # Order Item Count

  measure: order_item_count {
    group_label: "My Measures"
    type: count
    filters: [is_my_brand: "Yes"]
  }

  # Customer Count

  measure: customer_count {
    group_label: "My Measures"
    type: count_distinct
    sql: ${user_id} ;;
    filters: [is_my_brand: "Yes"]
  }

  # Product Count

  measure: product_count {
    group_label: "My Measures"
    type: count_distinct
    sql: ${product_sku} ;;
    filters: [is_my_brand: "Yes"]
  }

  # Total Sales Amount

  measure: total_sales_amount {
    group_label: "My Measures"
    type: sum
    sql: ${sale_price} ;;
    filters: [is_my_brand: "Yes"]
  }

  measure: total_sales_amount_previous_period {
    group_label: "My Measures"
    type: sum
    sql: ${sale_price} ;;
    filters: [is_my_brand: "Yes", period: "%Last%"]
  }

  measure: total_sales_amount_current_period {
    group_label: "My Measures"
    type: sum
    sql: ${sale_price} ;;
    filters: [is_my_brand: "Yes", period: "%This%"]
  }

}
