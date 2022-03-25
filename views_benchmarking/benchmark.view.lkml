view: benchmark {
  derived_table: {
    sql:
    {% assign num_dims = 1 %}
    {% assign pk = "concat('pk'" %}

    select

    {% if order_items.order_created._in_query %}
    {% assign num_dims = num_dims | plus: 1 %}
    {% assign pk = pk | append: ', cast(order_created as string) ' %}
    order_created,
    {% endif %}

    {% if order_items.country._in_query %}
    {% assign num_dims = num_dims | plus: 1 %}
    {% assign pk = pk | append: ', country ' %}
    country,
    {% endif %}

    {% if order_items.product_category._in_query %}
    {% assign num_dims = num_dims | plus: 1 %}
    {% assign pk = pk | append: ', product_category ' %}
    product_category,
    {% endif %}

    {% if order_items.status._in_query %}
    {% assign num_dims = num_dims | plus: 1 %}
    {% assign pk = pk | append: ', status ' %}
    status,
    {% endif %}

    {% if order_items.state._in_query %}
    {% assign num_dims = num_dims | plus: 1 %}
    {% assign pk = pk | append: ', state ' %}
    state,
    {% endif %}

    {{ pk | append: ")"}} as pk,

    sum(sale_price) as sale_price
    from `looker-ps-emea-consultants.the_look_perf_sam.order_items_order_struct_benchmark`
    where
    product_category in
     (select category from `looker-ps-emea-consultants.the_look_perf.products` products
     where brand = 'Allegra K'
     group by 1)

    group by 1{% for i in (2..num_dims) %},{{i}}{% endfor %}
    ;;
  }

  dimension: pk {
    primary_key: yes
  }

  dimension_group: order_created {
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
    sql: ${TABLE}.order_created_at ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: product_category {
    type: string
    sql: ${TABLE}.product_category ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  measure: total_sales_amount {
    group_label: "Benchmark Measures"
    type: sum
    sql: ${sale_price} ;;
  }

}
