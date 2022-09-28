view: status_dt {
  derived_table: {
    datagroup_trigger: current
    explore_source: order_items {
      column: created_date {}
      column: status {}
      column: benchmark_total_sales_amount {}
    }
  }
  dimension: created_date {
    label: "Transaction Information Created Date"
    description: ""
    type: date
  }
  dimension: status {
    label: "Transaction Information Status"
    description: ""
  }
  dimension: benchmark_total_sales_amount {
    label: "Transaction Information Benchmark Total Sales Amount"
    description: ""
    value_format: "$#,##0.00"
    type: number
  }
}
