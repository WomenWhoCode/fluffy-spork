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

    scope.find_each do |group_stat|
      next unless group_stat.urlname.present?
      Event.retrieve_events(group_stat)
    end
  end

  desc "pull rsvp data. Usage: rake data_import:rsvps['Women-Who-Code-Silicon-Valley']"
  task :rsvps, [:urlname] do |t, args|
    if args[:urlname].present?
      scope = Event.without_rsvp.where(group_urlname: args[:urlname])
    else
      scope = Event.without_rsvp
    end

    scope.find_each do |event|
      next unless event.group_urlname.present?
      RSVPQuestion.retrieve_answers(event)
    end
  end
end
