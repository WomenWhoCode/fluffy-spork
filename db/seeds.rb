group = GroupStat.first_or_create(
  group_id: 14429832,
  name: "Women Who Code Silicon Valley",
  urlname: "Women-Who-Code-Silicon-Valley"
)

event_data = [
  {
    event_id: "kxmpklytmbnc",
    time: "2015-10-01 01:30:00 UTC"
  },
]

event_data.each do |event|
  Event.find_or_create_by(event.merge(group_id: group.group_id, group_urlname: group.urlname))
end