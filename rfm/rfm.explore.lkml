include: "rfm_views.view"
include: "../views/*.view"

explore: rfm_model {
  label: "RFM"

  always_filter: {
    filters: [
      rfm_model.num_clusters: "5"
    ]
  }

  join: users {
    type: left_outer
    sql_on: ${rfm_model.user_id} = ${users.id} ;;
    relationship: one_to_one
  }

  join: order_items {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: one_to_many
  }

  # Inventory Items
  join: inventory_items {
    fields: [inventory_items.id]
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  # Products
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

}

# explore: rfm_model {
#   label: "RFM Model"
# }

# explore: rfm_final {
#   label: "RFM Final"
#   join: rfm_model {
#     sql:  ;;
#   relationship: one_to_one
#   }
#   always_join: [rfm_model]
# }
