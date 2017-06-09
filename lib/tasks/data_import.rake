namespace :data_import do
  desc "pull pro group data. Usage: rake data_import:pro_group['groupname']"
  task :pro_group, [:group] do |t, args|
    begin
      group = args[:group].presence || 'womenwhocode'
      m = Meetup::Api.new(data_type: ["pro", group, "groups"], options: {})
      data = m.get_response
      GroupStat.insert_records(data)

    rescue Exception => e
      Bugsnag.notify(e)
    end
  end
end
