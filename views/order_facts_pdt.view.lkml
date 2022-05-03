view: order_facts_pdt {
  derived_table: {
    datagroup_trigger: current
    partition_keys: ["created_at"]
    sql: SELECT created_at, sum(sale_price) FROM ${order_items.SQL_TABLE_NAME} GROUP BY 1 ;;
  }

  dimension_group: created {
    type: time
    sql: ${TABLE}.created_at ;;
  }
}
