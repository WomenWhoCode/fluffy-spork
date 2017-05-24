namespace :foo do
  desc "test task"
  task :test do
    puts "hello world"
  end

  desc "http client test"
  task :http_client_test do
    resp = HTTP.get('https://ghibliapi.herokuapp.com/films/58611129-2dbc-4a81-a72f-77ddfc1b1b49')
    puts resp.parse(:json)
  end

  desc "populate foos"
  task :populate do
    connection_details = YAML::load(File.open('config/database.yml'))[ENV["DATABASE_ENV"]]
    ActiveRecord::Base.establish_connection(connection_details)
    Foo.where(name: "foolala", published: true).first_or_create
  end
end
