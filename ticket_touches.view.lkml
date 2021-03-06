view: ticket_touches {
  derived_table: {
    sql: SELECT
        distinct ticket_id,
        FIRST_VALUE(CASE
                      WHEN audits.metadata__system__location LIKE '%Philippines%' THEN 'Philippines'
                      WHEN audits.metadata__system__location LIKE '%San Francisco%' THEN 'San Francisco'
                      WHEN audits.metadata__system__location LIKE '%Mountain View%' THEN 'San Francisco'
                      WHEN audits.metadata__system__location LIKE '%Englewood, CO%' THEN 'Mexico'
                      WHEN audits.metadata__system__location LIKE '%Mexico%' THEN 'Mexico'
                      WHEN audits.metadata__system__location LIKE '%United States%' THEN 'United States'
                      WHEN audits.metadata__system__location LIKE '%Canada%' THEN 'Canada'
                      WHEN audits.metadata__system__location LIKE '%United Kingdom%' THEN 'UK'
                      WHEN audits.metadata__system__location LIKE '%United Arab Emirates%' THEN 'UAE'
                      ELSE 'Other' END) OVER (PARTITION BY ticket_id ORDER BY audits.created_at ASC) AS first_touch_agent_location,
        FIRST_VALUE(users.id) OVER (PARTITION BY ticket_id ORDER BY audits.created_at ASC) AS first_touch_agent_id,
        FIRST_VALUE(audits.created_at) OVER (PARTITION BY ticket_id ORDER BY audits.created_at ASC) AS first_touch_created_at,
        FIRST_VALUE(CASE
                      WHEN audits.metadata__system__location LIKE '%Philippines%' THEN 'Philippines'
                      WHEN audits.metadata__system__location LIKE '%San Francisco%' THEN 'San Francisco'
                      WHEN audits.metadata__system__location LIKE '%Mountain View%' THEN 'San Francisco'
                      WHEN audits.metadata__system__location LIKE '%Englewood, CO%' THEN 'Mexico'
                      WHEN audits.metadata__system__location LIKE '%Mexico%' THEN 'Mexico'
                      WHEN audits.metadata__system__location LIKE '%United States%' THEN 'United States'
                      WHEN audits.metadata__system__location LIKE '%Canada%' THEN 'Canada'
                      WHEN audits.metadata__system__location LIKE '%United Kingdom%' THEN 'UK'
                      WHEN audits.metadata__system__location LIKE '%United Arab Emirates%' THEN 'UAE'
                      ELSE 'Other' END) OVER (PARTITION BY ticket_id ORDER BY audits.created_at DESC) AS last_touch_agent_location,
        FIRST_VALUE(users.id) OVER (PARTITION BY ticket_id ORDER BY audits.created_at DESC) AS last_touch_agent_id,
        FIRST_VALUE(audits.created_at) OVER (PARTITION BY ticket_id ORDER BY audits.created_at DESC) AS last_touch_created_at
      FROM
        zendesk_stitch.ticket_audits AS audits
      LEFT JOIN
        zendesk_stitch.users AS users
      ON
        users.id = audits.author_id
      LEFT JOIN
        zendesk_stitch.ticket_audits__events as events
      ON
        events._sdc_source_key_id = audits.id
      WHERE
          (users.role = 'agent' OR users.role = 'admin')
        AND
          users.email != 'zendesk@getaround.com'
        AND
          ((events.public = true
           AND
          events.type = 'Comment')
        OR
          audits.via__channel = 'voice')
       ;;
    indexes: ["ticket_id"]
    sql_trigger_value: SELECT COUNT(*) FROM zendesk_stitch.ticket_audits ;;
  }

 dimension: ticket_id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}.ticket_id ;;
  }

  dimension: first_touch_agent_location {
    description: "Location of agent who was the first agent to make a change to the ticket"
    view_label: "Ticket First Touch"
    group_label: "First Touch"
    type: string
    sql: ${TABLE}.first_touch_agent_location ;;
  }

  dimension: first_touch_agent_id {
    description: "ID of agent who was the first agent to make a change to the ticket"
    view_label: "Ticket First Touch"
    group_label: "First Touch"
    type: string
    hidden: yes
    sql: ${TABLE}.first_touch_agent_id ;;
  }

  dimension_group: time_first_touch_at {
    description: "First Touch At, in the timezone specified by the Looker user"
    view_label: "Ticket First Touch"
    group_label: "Time First Touch At"
    label: "First Touch At"
    type: time
    timeframes: [
      raw,
      time,
      date,
      time_of_day,
      week,
      month,
      quarter,
      hour_of_day,
      day_of_week,
      day_of_week_index,
      day_of_month,
      year,
      week_of_year,
      month_num,
      quarter_of_year
    ]
    sql: ${TABLE}.first_touch_created_at ;;
  }


  dimension_group: time_first_touch_at_utc {
    description: "First Touch At, in UTC"
    view_label: "Ticket First Touch"
    group_label: "Time First Touch At"
    label: "First Touch At UTC"
    type: time
    timeframes: [
      raw,
      time,
      date,
      time_of_day,
      week,
      month,
      quarter,
      hour_of_day,
      day_of_week,
      day_of_week_index,
      day_of_month,
      year,
      week_of_year,
      month_num,
      quarter_of_year
    ]
    sql: ${TABLE}.first_touch_created_at ;;
    convert_tz: no
  }

  dimension: last_touch_agent_location {
    description: "Location of agent who was the last agent to make a change to the ticket"
    view_label: "Ticket Last Touch"
    group_label: "Last Touch"
    type: string
    sql: ${TABLE}.last_touch_agent_location ;;
  }

  dimension: last_touch_agent_id {
    description: "ID of agent who was the last agent to make a change to the ticket"
    view_label: "Ticket Last Touch"
    group_label: "Last Touch"
    type: string
    hidden: yes
    sql: ${TABLE}.last_touch_agent_id ;;
  }

  dimension_group: last_touch_at {
    description: "Last Touch At, in the timezone specified by the Looker user"
    view_label: "Ticket Last Touch"
    group_label: "Time Last Touch At"
    label: "Last Touch At"
    type: time
    timeframes: [
      raw,
      time,
      date,
      time_of_day,
      week,
      month,
      quarter,
      hour_of_day,
      day_of_week,
      day_of_week_index,
      day_of_month,
      year,
      week_of_year,
      month_num,
      quarter_of_year
    ]
    sql: ${TABLE}.last_touch_created_at ;;
  }

  dimension_group: last_touch_at_utc {
    description: "Last Touch At, in UTC"
    view_label: "Ticket Last Touch"
    group_label: "Time Last Touch At"
    label: "Last Touch At UTC"
    type: time
    timeframes: [
      raw,
      time,
      date,
      time_of_day,
      week,
      month,
      quarter,
      hour_of_day,
      day_of_week,
      day_of_week_index,
      day_of_month,
      year,
      week_of_year,
      month_num,
      quarter_of_year
    ]
    sql: ${TABLE}.last_touch_created_at ;;
    convert_tz: no
  }

  set: default {
    fields: [
      ticket_id,
      first_touch_agent_location,
      time_first_touch_at_date,
      last_touch_agent_location,
      last_touch_at_time
    ]
  }
}
