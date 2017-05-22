#!/usr/bin/env ruby

require 'pg'

# Output a table of current connections to the DB
conn = PG.connect( dbname: 'postgres' )
conn.exec( "SELECT * FROM pg_stat_activity" ) do |result|
  puts "     PID | User             | Query"
  result.each do |row|
    puts " %7d | %-16s | %s " %
      row.values_at('pid', 'usename', 'current_query')
  end
end
