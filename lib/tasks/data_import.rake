namespace :data_import do
  desc "pull pro group data. Usage: rake data_import:pro_group['groupname']"
  task :pro_group, [:group] do |t, args|
    begin
      group = args[:group].presence || 'womenwhocode'
      m = Meetup::Api.new(data_type: ["pro", group, "groups"])
      data = m.get_response
      while data
        GroupStat.insert_records(data)
        data = m.get_next_page(Date.today)
      end

    rescue Exception => e
      Bugsnag.notify(e)
    end
  end

  desc "pull event data. Usage: rake data_import:events['Women-Who-Code-Silicon-Valley']"
  task :events, [:urlname] do |t, args|
    scope = args[:urlname].present? ? GroupStat.where(urlname: args[:urlname]) : GroupStat.all

    meetup_api = Meetup::Api.new(data_type: [])
    scope.find_each do |group_stat|
      next unless group_stat.urlname.present?

      meetup_api.reset_data_options(
        data_type: [group_stat.urlname, "events"],
        options: group_stat.get_last_event_time_option
      )
      Event.retrieve_events(group_stat, meetup_api)
    end
  end

  desc "pull rsvp data. Usage: rake data_import:rsvps['Women-Who-Code-Silicon-Valley']"
  task :rsvps, [:urlname] do |t, args|
    if args[:urlname].present?
      scope = Event.without_rsvp.where(group_urlname: args[:urlname])
    else
      scope = Event.without_rsvp
    end

    meetup_api = Meetup::Api.new(data_type: [])
    scope.find_each do |event|
      next unless event.group_urlname.present?

      meetup_api.reset_data_options(
        data_type: [event.group_urlname, "events", event.event_id, "rsvps"],
        options: {fields: "answers"}
      )
      RSVPQuestion.retrieve_answers(event, meetup_api)
    end
  end
end
