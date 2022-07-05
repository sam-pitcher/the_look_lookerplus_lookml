view: order_items_denorm {
  view_label: "Orders"
  derived_table: {
    datagroup_trigger: current
    # partition_keys: ["order_date"]
    # cluster_keys: ["products_brand"]
    create_process: {
      sql_step:
      {% assign levels = 'department, brand, sku' | split: ',' %}
      {% assign levels_list = ',' split: ',' %}
      {% for i in levels %}
      {% assign levels_list = levels_list | append: i %}
      {% for j in levels_list %}
      CREATE TABLE AS `lookerplus.the_look.order_items_{{j}}` (
      SELECT
      products.{{j}} AS products_{{j}},
      {% endfor %}
      (DATE(order_items.created_at )) AS order_date,
      SUM(order_items.sale_price) AS sales_amount,
      ARRAY_AGG(DISTINCT order_items.order_id) AS order_id_array,
      HLL_COUNT.INIT(DISTINCT order_items.order_id, 24) AS order_id_sketch

      FROM `lookerplus.the_look.order_items` AS order_items
      LEFT JOIN `lookerplus.the_look.inventory_items`
        AS inventory_items ON order_items.inventory_item_id = inventory_items.id
      LEFT JOIN `lookerplus.the_look.products`
       AS products ON inventory_items.product_id = products.id
      GROUP BY
      1,2,3,4,5,6 ) -- also need to add one to group by each iteration
      {% endfor %}
      ;;
    sql_step: CREATE TABLE ${SQL_TABLE_NAME} AS (SELECT 1) ;;
    }
  }

  dimension_group: order {
    type: time
    sql: ${TABLE}.order_date ;;
    datatype: date
    timeframes: [
      date,
      month,
      year
    ]
  }

  dimension: pk {primary_key:yes hidden:yes}
  dimension: products_sku {}
  dimension: products_category {}
  dimension: products_department {}
  dimension: sales_amount {hidden:yes}
  dimension: order_id_array {hidden:yes}
  dimension: order_id_sketch {hidden:yes}

  measure: total_sales_amount {
    type: sum
    sql: ${sales_amount} ;;
    value_format_name: usd
  }

  measure: transaction_count_hll {
    type: number
    sql: HLL_COUNT.MERGE(${order_id_sketch}) ;;
  }

}

view: order_items_denorm__order_id_array {
  sql_table_name: order_id_array ;;
  view_label: "Orders"
  measure: transaction_count {
    type: count_distinct
    sql: order_items_denorm__order_id_array ;;
  }
}
