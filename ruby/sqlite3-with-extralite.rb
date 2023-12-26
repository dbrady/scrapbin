#!/usr/bin/env ruby
require "colorize"
require "extralite"

DATABASE=File.join(Dir.getwd, "test-db.sqlite3")

cmd = "rm -f #{DATABASE}"
system cmd

puts "Open or create a sqlite3 database with Database.new(path_to_sqlite_file)"
puts "db = Extralite::Database.new #{DATABASE.inspect}".cyan
db = Extralite::Database.new DATABASE
puts

puts "You can execute commands (such as DDL) with db.execute(query)"
# DDL STUFF
query = "CREATE TABLE users (
      id INTEGER NOT NULL PRIMARY KEY,
      name TEXT,
      age INTEGER,
-- position INTEGER DEFAULT 0,
      created_at DATETIME DEFAULT current_timestamp
)";
puts "db.execute(#{query})".cyan
puts db.execute(query)
puts

# DATABASE/QUERY INTROSPECTION
# db.tables => list of table names
# db.columns(query) => list of column names
puts "You can introspect the database, sorta, with db.tables() and db.columns(query)."
puts "By 'sorta' I mean: db.columns(query) returns an array of symbols (the column names that the query returns), but not their types."
puts "tables = db.tables".cyan
puts db.tables.inspect
puts

# Using PRAGMA table_info(table)
puts "For full table info, as if querying information_schema.columns on a 'proper' dbms, sqlite3 provides PRAGMA table_info(table):"
query = "PRAGMA table_info(users)"
puts "db.query(#{query.inspect})".cyan
puts db.query(query).inspect
puts

# Getting the CREATE command from sqlite_master
puts "You can also get the create table statement from sqlite_master. Note also the use of db.query_single_column."
query = "SELECT sql FROM sqlite_master WHERE name = 'users' AND type = 'table'"
puts "db.query_single_column(#{query.inspect})".cyan
puts db.query_single_column(query)

# TIL that  sqlite_master is a thing, and its sql type contains your
# original sql query, and if you ALTER TABLE it will jam in its own programmatic
# edits to your sql.
#
# TODO: Maybe make a longer tut on sqlite_master. Seems like information_schema,
# but lite.
puts

db.tables.each do |table|
  puts %Q|db.columns("SELECT * FROM #{table})"|.cyan
  puts db.columns("SELECT * FROM #{table}").inspect
end
puts


users1 = [
  {name: 'Alice', age: 29},
  {name: 'Bob', age: 17},
  {name: 'Carol', age: 13},
  {name: 'Dave', age: 52},
  {name: 'Eddie', age: 11},
  {name: 'Frances', age: 16},
  {name: 'George', age: 21},
  {name: 'Hannah', age: 22},
]

code = <<CODE
db.transaction do
  users1.each do |user|
    query = "INSERT INTO users (name, age) VALUES ('\#{user[:name]}', \#{user[:age]})"
    puts "db.execute(\#{query.inspect})".cyan
    puts db.execute(query)
  end
  puts "db.total_changes: \#{db.total_changes}".cyan
end
CODE
puts code.cyan

db.transaction do
  users1.each do |user|
    query = "INSERT INTO users (name, age) VALUES ('#{user[:name]}', #{user[:age]})"
    puts "db.execute(#{query.inspect})".cyan
    puts db.execute(query)
  end
  puts "db.total_changes: #{db.total_changes}".cyan
end
puts

puts "db.query and db.query_hash are similar; use db.query_ary to get an array of arrays instead."
query = "SELECT * FROM users WHERE age >= 18 ORDER BY name"
puts "db.query(#{query.inspect})".cyan
db.query(query).each do |row|
  puts row.inspect
end
puts

code = <<CODE
# BONUS: Let's use sequel
require "sequel" # gem install sqlite3 sequel
sequel_db = Sequel.connect(DATABASE)
users = sequel_db[:users]

users2 = [
  {name: "Ian", age: 99},
  {name: "Janice", age: 88},
  {name: "Karl", age: 11},
  {name: "Lana", age: 11}
]

users.multi_insert(users2)
CODE
puts code.green

# BONUS: Let's use sequel!
# Note: I use extralite because it's easier and faster than the sqlite3 gem, but
# the sequel gem depends on it, so you still need to `gem install sqlite3`
require "sequel" # gem install sqlite3 sequel
sequel_db = Sequel.connect("sqlite:///#{DATABASE}")
users = sequel_db[:users]

users2 = [
  {name: "Ian", age: 99},
  {name: "Janice", age: 88},
  {name: "Karl", age: 11},
  {name: "Lana", age: 11}
]

users.multi_insert(users2)
query = "SELECT * FROM users WHERE age >= 18 ORDER BY name"
puts "db.query(#{query.inspect})".cyan
db.query(query).each do |row|
  puts row.inspect
end
puts
