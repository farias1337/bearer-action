require 'json'
require 'net/http'
require 'sqlite3'

# Vulnerable Code Example

# SQL Injection
def get_user(user_id)
  db = SQLite3::Database.new 'users.db'
  query = "SELECT * FROM users WHERE id = #{user_id};"
  result = db.execute(query)
  db.close
  result
end

# Command Injection
def execute_command(user_input)
  system("echo #{user_input}")
end

# Insecure Deserialization
class User
  attr_accessor :name, :email

  def initialize(name, email)
    @name = name
    @email = email
  end

  def to_json(*_args)
    { name: @name, email: @email }.to_json
  end

  def self.from_json(json)
    data = JSON.parse(json)
    new(data['name'], data['email'])
  end
end

def load_user_from_file(filename)
  file_content = File.read(filename)
  user = User.from_json(file_content)
  user
end

# Inadequate Input Validation
def validate_and_print_email(email)
  if email =~ /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
    puts "Valid email: #{email}"
  else
    puts "Invalid email format"
  end
end

# Sample Usage
puts "Enter user ID:"
user_id = gets.chomp
puts "User details: #{get_user(user_id)}"

puts "Enter a command:"
command = gets.chomp
execute_command(command)

puts "Enter filename to load user data:"
filename = gets.chomp
user = load_user_from_file(filename)
puts "Loaded user: #{user.name}, #{user.email}"

puts "Enter email to validate:"
email = gets.chomp
validate_and_print_email(email)
