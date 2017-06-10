module Retrievable
  extend ActiveSupport::Concern

  DATE_FIELDS = %w(founded_date pro_join_date last_event next_event)

  module ClassMethods
    def insert_records(records)
      records.each do |record|
        obj = self.where("#{meetup_primary_key}": record["id"]).first_or_create
        record.delete("id")
        record.each do |k, v|
          setter = "#{k}="
          next unless obj.respond_to?(setter)
          if DATE_FIELDS.include?(k)
            obj.send(setter, DateTime.strptime("#{v}",'%Q'))
          else
            obj.send(setter, v)
          end
        end
        obj.save
      end
    end
  end
end
