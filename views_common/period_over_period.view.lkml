view: period_over_period {

  extension: required

  ######################
  #   DATE SELCTIONS   #
  ######################

  filter: current_date_range {
    type: date
    view_label: "-- Period over Period"
    label: "Date Range"
    description: "Select the date range you are interested in using this filter, can be used by itself. Make sure any filter on Event Date covers this period, or is removed."
    sql: ${period} IS NOT NULL ;;
    convert_tz: yes
  }

  parameter: compare_to {
    view_label: "-- Period over Period"
    description: "Choose the period you would like to compare to. Must be used with Current Date Range filter"
    label: "Compare To:"
    type: unquoted
    allowed_value: {
      label: "Previous Period"
      value: "Period"
    }
    allowed_value: {
      label: "Previous Iso Year"
      value: "IsoYear"
    }
    allowed_value: {
      label: "Previous Calendar Week"
      value: "Week"
    }
    allowed_value: {
      label: "Previous Calendar Month"
      value: "Month"
    }
    allowed_value: {
      label: "Previous Calendar Year"
      value: "Year"
    }
    default_value: "Period"
  }

  dimension_group: pop_no_tz {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date
    ]
    convert_tz: no
  }

  ###############
  #   PERIODS   #
  ###############

  dimension_group: in_period {
    hidden: yes
    view_label: "-- Period over Period"
    type: duration
    intervals: [day]
    description: "Gives the number of days in the current period date range"
    sql_start: {% date_start current_date_range %} ;;
    sql_end: {% date_end current_date_range %} ;;
  }

  dimension: period_1_start {
    hidden: yes
    view_label: "-- Period over Period"
    # type: date_time
    type: date
    sql: {% date_start current_date_range %} ;;
    # convert_tz: no
  }

  dimension: period_1_end {
    hidden: yes
    # type: date_time
    type: date
    view_label: "-- Period over Period"
    sql: DATE_SUB(CAST({% date_end current_date_range %} AS DATE), INTERVAL 1 DAY) ;;
    # convert_tz: no
  }

  # SELECT DATE_SUB(CURRENT_DATE, INTERVAL (DATE_DIFF(DATE(EXTRACT(YEAR FROM CURRENT_DATE) - 1 , 12 ,31 ), DATE(EXTRACT(YEAR FROM CURRENT_DATE) - 1 , 1 ,1 ), ISOWEEK)) WEEK)

  dimension: period_2_start {
    hidden: yes
    view_label: "-- Period over Period"
    description: "Calculates the start of the previous period"
    # type: date_raw
    type: date
    sql:
    {% if compare_to._parameter_value == "Period" %}
      DATE_SUB(${period_1_start} , INTERVAL ${days_in_period} DAY)
    {% elsif compare_to._parameter_value == "IsoYear" %}
      DATE_SUB(${period_1_start}, INTERVAL (DATE_DIFF(DATE(EXTRACT(YEAR FROM ${period_1_start}) - 1 , 12 ,31 ), DATE(EXTRACT(YEAR FROM ${period_1_start}) - 1 , 1 ,1 ), ISOWEEK)) WEEK)
    {% else %}
      DATE_SUB(${period_1_start}, INTERVAL 1 {% parameter compare_to %})
    {% endif %}
     ;;
  }

  dimension: period_2_end {
    hidden: yes
    view_label: "-- Period over Period"
    description: "Calculates the end of the previous period"
    # type: date_raw
    type: date
    sql:

    {% if compare_to._parameter_value == "Period" %}
      DATE_SUB(${period_1_start}, INTERVAL 0 DAY)
    {% elsif compare_to._parameter_value == "IsoYear" %}
      DATE_SUB(${period_1_end}, INTERVAL (DATE_DIFF(DATE(EXTRACT(YEAR FROM ${period_1_end}) - 1 , 12 ,31 ), DATE(EXTRACT(YEAR FROM ${period_1_end}) - 1 , 1 ,1 ), ISOWEEK)) WEEK)
    {% else %}
      DATE_SUB(${period_1_end}, INTERVAL 1 {% parameter compare_to %})
    {% endif %}
 ;;
  }

  dimension: day_in_period {
    hidden: yes
    view_label: "-- Period over Period"
    description: "Gives the number of days since the start of each periods. Use this to align the event dates onto the same axis, the axes will read 1,2,3, etc."
    type: number
    sql:
    {% if current_date_range._is_filtered %}
      CASE

        WHEN ${pop_no_tz_date} between ${period_1_start} and ${period_1_end}
        THEN DATE_DIFF(${pop_no_tz_date}, ${period_1_start}, DAY )

        WHEN ${pop_no_tz_date} between ${period_2_start} and ${period_2_end}
        THEN DATE_DIFF(${pop_no_tz_date}, ${period_2_start}, DAY )

      END

    {% else %} NULL
    {% endif %} ;;
  }

  ##########################
  #   HIDDEN DIMESNSIONS   #
  ##########################

  # dimension: period_order {
  #   view_label: "-- Period over Period"
  #   description: "Assigns 1 to Previous Period and 2 to Current Period"
  #   type: string
  #   sql:
  #     {% if current_date_range._is_filtered %}
  #       CASE
  #         WHEN ${pop_no_tz_raw} between CAST(${period_1_start} AS TIMESTAMP) and CAST(${period_1_end} AS TIMESTAMP)
  #         THEN 2
  #         WHEN ${pop_no_tz_raw} between ${period_2_start} and ${period_2_end}
  #         THEN 1
  #       END
  #     {% else %}
  #       NULL
  #     {% endif %}
  #     ;;
  # }

  ##########################
  #   DIMENSIONS TO PLOT   #
  ##########################

  dimension: period {
    view_label: "-- Period over Period"
    label: "Period"
    description: "Returns the period the metric covers, i.e. either the 'This Period' or 'Previous Period'"
    type: string
    sql:
       {% if current_date_range._is_filtered %}
         CASE
           WHEN ${pop_no_tz_date} between ${period_1_start} and ${period_1_end}
           THEN 'This {% parameter compare_to %}'
           WHEN ${pop_no_tz_date} between ${period_2_start} and ${period_2_end}
           THEN 'Last {% parameter compare_to %}'
         END
       {% else %}
         NULL
       {% endif %}
       ;;
    # order_by_field: period_order
    }

    dimension_group: date_in_period {
      view_label: "-- Period over Period"
      description: "Use this as your date dimension when comparing periods. Aligns the previous periods onto the current period"
      label: "Current Period"
      type: time
      sql: DATE_ADD(${period_1_start}, INTERVAL (${day_in_period}) DAY) ;;
      timeframes: [date, week, month, quarter, year]
    }

  }
