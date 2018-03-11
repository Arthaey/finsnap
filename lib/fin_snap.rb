require "yaml"
require "terminal-table"

require "extensions/object"
require "institution"

class FinSnap

  def initialize(config_filename)
    config = YAML::load_file(File.open(config_filename)).deep_symbolize_keys
    @sources = config[:sources]
  end

  def run!
    net_worth = Money.new(0, "USD")
    institutions = []

    @sources.each do |name, info|
      institution = Institution.login(name, info[:username], info[:password])
      puts institution.name.upcase
      institution.accounts.each do |account|
        net_worth += account.balance
        sign = account.balance.negative? ? "-" : "+"
        amount = account.balance.abs.format.rjust(10)
        puts "#{sign}  #{amount}   #{account.name} [#{account.type}]"
      end
    end

    now = DateTime.now.strftime("%a %Y-%m-%d at %I:%M %p")

    puts
    puts "NET WORTH"
    puts "=  #{net_worth.format.rjust(10)} (as of #{now})"
  end

end
