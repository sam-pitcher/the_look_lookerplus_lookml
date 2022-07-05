view: rfm_dt {
  derived_table: {
    explore_source: order_items {
      column: user_id { field: users.id }
      column: total_sales_amount {}
      column: order_count {}
      column: days_since_last_order {}
    }
  }
  dimension: user_id {
    hidden: yes
    primary_key: yes
    type: number
  }
  dimension: total_sales_amount {
    hidden: yes
    type: number
  }
  dimension: order_count {
    hidden: yes
    type: number
  }
  dimension: days_since_last_order {
    hidden: yes
    type: number
  }
}

view: rfm_model {
  extends: [rfm_dt]
  derived_table: {
    persist_for: "1 hour"
    create_process: {
      sql_step:
    CREATE OR REPLACE MODEL `lookerplus.rfm.RFM_Model_{{ rfm_model.num_clusters._parameter_value }}`
      OPTIONS(
        model_type = 'kmeans',
        num_clusters = {{ rfm_model.num_clusters._parameter_value }},
        standardize_features = true
      ) AS

    SELECT * except (user_id) from ${rfm_dt.SQL_TABLE_NAME} ;;

    sql_step:
    {% assign var_num_clusters = rfm_model.num_clusters._parameter_value %}
    CREATE OR REPLACE TABLE ${SQL_TABLE_NAME} AS (
      SELECT
      CASE
        {% for i in (1..var_num_clusters) %}
        WHEN CENTROID_ID = {{i}} then 'Segment {{i}}'
        {% endfor %}
      END as segments,
      * except (nearest_centroids_distance)

      FROM ML.PREDICT(
        MODEL `lookerplus.rfm.RFM_Model_{{ rfm_model.num_clusters._parameter_value }}`,
        (select * from ${rfm_dt.SQL_TABLE_NAME})
      )
    ) ;;
    }
  }

  parameter: num_clusters {
    type: number
  }

  dimension: segment {
    view_label: "Users"
    sql: ${TABLE}.segments ;;
  }

}

# view: rfm_final {
#   extends: [rfm_dt]
#   derived_table: {
#     persist_for: "1 hour"
#     sql:
#     ;;
#   }


# }
