view: users {
  sql_table_name: zendesk_stitch.users ;;

  dimension: id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}.id ;;
  }

  dimension: alias {
    description: "The Zendesk user’s alias, displayed to Getaround's users"
    type: string
    sql: ${TABLE}.alias ;;
  }

  dimension_group: time_created_at {
    description: "Timestamp when the Zendesk user was created at, in the timezone specified by the Looker user"
    group_label: "Time Created At"
    label: "Created At"
    type: time
    hidden: no
    timeframes: [
      time,
      date,
      week,
      month
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    description: "The Zendesk user’s primary email address"
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: name {
    description: "The Zendesk user’s full name"
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: organization_id {
    type: number
    hidden: yes
    value_format_name: id
    sql: ${TABLE}.organization_id ;;
  }

  dimension: role {
    description: "The role of the Zendesk user. Possible values: agent, admin, end-user"
    type: string
    sql: ${TABLE}.role ;;
  }

  dimension: timezone {
    description: "The Zendesk user’s timezone"
    type: string
    hidden: yes
    sql: ${TABLE}.time_zone ;;
  }

  dimension: bpo_site {
    label: "BPO Site"
    description: "Location of third-party service provider."
    type: string
    sql: UPPER(${TABLE}.user_fields__bpo_site) ;;
  }

  dimension: team_lead {
    description: "Name of the team lead responsible for the management of a particular agent."
    type: string
    sql: INITCAP(REPLACE(${TABLE}.user_fields__team_lead,'_',' ')) ;;
  }

  dimension_group: time_bpo_cohort_start_at {
    description: "Week that the third-party service provider started, used to define BPO cohorts.  This is a user-created field and doesn't have a specific timezone."
    group_label: "Time BPO Cohort Start At"
    label: "BPO Cohort Start At"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.user_fields__bpo_start_date::DATE ;;
    convert_tz: no
  }


  ### Measures

  measure: count {
    description: "Count Zendesk users"
    type: count
    drill_fields: [id, name]
  }
}
