- dashboard: the_look_overview
  title: The Look Overview
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: CE4sMlvlcLo5EPDOTFrOiF
  elements:
  - title: Total Sales
    name: Total Sales
    model: the_look_lookerplus
    explore: order_items
    type: single_value
    fields: [order_items.total_sales_amount]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    row: 0
    col: 0
    width: 24
    height: 6
