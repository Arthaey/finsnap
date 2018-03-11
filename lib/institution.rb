require "mechanize"
require "monetize"

require "extensions/string"
require "account"

class Institution

  attr_reader :key, :name, :accounts

  def initialize(key, username, password, login_page_info, account_page_info)
    @key = key
    @username = username
    @password = password
    @login_page_info = login_page_info
    @account_page_info = account_page_info

    @name = key.to_s.gsub(/[[:punct:]]/, " ").titlecase
    @accounts = []
  end

  def to_s
    @name
  end

  def fetch_accounts!
    @accounts = []

    agent = Mechanize.new

    login_page = agent.get(@login_page_info[:url])

    login_form = login_page.form_with(css: @login_page_info[:form])
    login_form.at(@login_page_info[:username])["value"] = @username
    login_form.at(@login_page_info[:password])["value"] = @password
    accounts_page = login_form.click_button

    accounts = accounts_page.search(@account_page_info[:account])
    accounts.each do |account|
      name = account.at(@account_page_info[:name]).text
      type = account.at(@account_page_info[:type]).text
      balance = Monetize.parse(account.at(@account_page_info[:balance]).text)
      @accounts << Account.new(name, type, balance)
    end

    @accounts
  end

end
