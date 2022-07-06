view: order_facts_pdt {
  derived_table: {
    datagroup_trigger: hour
    partition_keys: ["created_at"]
    sql: SELECT created_at, sum(sale_price) FROM ${order_items.SQL_TABLE_NAME} GROUP BY 1 ;;
  }

  dimension_group: created {
    type: time
    sql: ${TABLE}.created_at ;;
  }
}

view: order_facts_pdt_user_attribute {
  derived_table: {
    datagroup_trigger: hour
    partition_keys: ["created_at"]
    sql: SELECT created_at, "{{ _user_attributes['test_for_pdt_build'] }}", sum(sale_price) FROM ${order_items.SQL_TABLE_NAME} GROUP BY 1,2 ;;
  }

  dimension_group: created {
    type: time
    sql: ${TABLE}.created_at ;;
  }
}

view: order_facts_pdt_ndt {
  derived_table: {
    datagroup_trigger: hour
    explore_source: order_items {
      column: test_for_pdt_build_dim {}
    }
  }
  dimension: test_for_pdt_build_dim {
    label: "Transaction Information Test for Pdt Build Dim"
    description: ""
  }
}
