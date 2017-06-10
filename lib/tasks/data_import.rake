namespace :data_import do
  desc "pull pro group data. Usage: rake data_import:pro_group['groupname']"
  task :pro_group, [:group] do |t, args|
    begin
      group = args[:group].presence || 'womenwhocode'
      m = Meetup::Api.new(data_type: ["pro", group, "groups"], options: {})
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
    urlname = args[:urlname]
    abort("urlname parameter required: rake data_import:events['Women-Who-Code-Silicon-Valley']") unless urlname.present?

    begin
      m = Meetup::Api.new(data_type: [urlname, "events"], options: {})
      data = m.get_response
      Event.insert_records(data)

    rescue Exception => e
      Bugsnag.notify(e)
    end
  end
end
