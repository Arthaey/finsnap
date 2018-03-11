require "money"
I18n.enforce_available_locales = false

class Account
  attr_reader :balance, :name, :type

  def initialize(name, type, balance)
    @name = name
    @type = type.to_sym
    @balance = balance
  end

  def to_s
    @name
  end
end
