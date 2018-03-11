require "extensions/string"
require "account"

class Institution
  attr_reader :key, :name

  def initialize(key, username, password)
    @key = key
    @name = key.to_s.gsub(/[[:punct:]]/, " ").titlecase
    @username = username
    @password = password
  end

  def login!
    puts "LOGIN #{@name} as #{@username}." # DELETE ME
  end

  def accounts
    [
      Account.new("Foo", :checking, 1234_00),
      Account.new("Bar", :credit, -3_14),
    ]
  end

  def to_s
    @name
  end

  def self.login(name, username, password)
    institution = Institution.new(name, username, password)
    institution.login!
    institution
  end
end
