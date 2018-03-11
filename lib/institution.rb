require "mechanize"
require "monetize"

require "extensions/string"
require "account"

class Institution

  attr_reader :key, :name, :accounts

  def initialize(key, username, password, login_url)
    @key = key
    @username = username
    @password = password
    @login_url = login_url

    @name = key.to_s.gsub(/[[:punct:]]/, " ").titlecase
    @accounts = []
  end

  def to_s
    @name
  end

  def fetch_accounts!
    @accounts = []

    agent = Mechanize.new

    login_page = agent.get(@login_url)

    accounts_page = login_page.form_with(:id => "login") do |form|
      form.username = @username
      form.password = @password
    end.click_button

    accounts = accounts_page.search(".account")
    accounts.each do |account|
      name = account.at(".name").text
      type = account.at(".type").text
      balance = Monetize.parse(account.at(".balance").text)
      @accounts << Account.new(name, type, balance)
    end

    @accounts
  end

end
