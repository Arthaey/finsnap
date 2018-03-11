require "mechanize"
require "monetize"

require "extensions/string"
require "account"

class Institution

  attr_reader :key, :name, :accounts

  def initialize(key, username, password, login_page, accounts_page)
    @key = key
    @username = username
    @password = password

    @login_url = login_page.delete(:url)
    @login_selectors = login_page
    @accounts_selectors= accounts_page

    @name = key.to_s.gsub(/[[:punct:]]/, " ").titlecase
    @accounts = []
  end

  def to_s
    @name
  end

  def fetch_accounts!
    @accounts = []
    accounts_page = login!
    @accounts = find_accounts!(accounts_page)
  end

  private

  def login!
    login_page = Mechanize.new.get(@login_url)
    login_form = login_page.form_with(css: @login_selectors[:form])
    login_form.field_with(css: @login_selectors[:username]).value = @username
    login_form.field_with(css: @login_selectors[:password]).value = @password
    accounts_page = login_form.submit
  end

  def find_accounts!(accounts_page)
    accounts = []

    account_elements = accounts_page.search(@accounts_selectors[:account])
    account_elements.each do |account|
      name = account.at(@accounts_selectors[:name]).text
      type = account.at(@accounts_selectors[:type]).text
      balance = Monetize.parse(account.at(@accounts_selectors[:balance]).text)
      accounts << Account.new(name, type, balance)
    end

    accounts
  end

end
