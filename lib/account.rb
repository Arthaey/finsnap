require "money"
I18n.enforce_available_locales = false

class Account
  attr_reader :balance, :name, :type

  def initialize(name, type, balance_cents)
    @name = name
    @type = type
    @balance = Money.new(balance_cents, "USD")
  end

  def to_s
    @name
  end
end
