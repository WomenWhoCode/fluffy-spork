class GroupStat < ActiveRecord::Base
  DATE_FIELDS = %w(founded_date pro_join_date last_event next_event)

  class << self
    def insert_records(records)
      records.each do |record|
        group_stat = self.where(group_id: record["id"]).first_or_create
        record.delete("id")
        record.each do |k,v|
          setter = "#{k}="
          next unless group_stat.respond_to?(setter)
          if DATE_FIELDS.include?(k)
            group_stat.send(setter, DateTime.strptime("#{v}",'%Q'))
          else
            group_stat.send(setter,v)
          end
        end
        group_stat.save
      end
    end
  end
end
