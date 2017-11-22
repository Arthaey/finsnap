require_relative "account"

class Institution
  def self.login(name, username, password)
    institution = Institution.new(name, username, password)
    institution.login!
    institution
  end

  def initialize(name, username, password)
    @name = name
    @username = username
    @password = password
  end

  def login!
    puts "LOGIN #{@name} as #{@username}." # DELETE ME
  end

  def accounts
    [
      Account.new(self, "Foo", :checking),
      Account.new(self, "Bar", :saving),
    ]
  end

  def to_s
    @name.to_s.gsub(/[[:punct:]]/, " ").titlecase
  end
end
