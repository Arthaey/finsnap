require "yaml"

require "extensions/object"
require "institution"

class FinSnap

  def initialize(institutions_filename, credentials_filename)
    credentials = YAML::load_file(File.open(credentials_filename)).deep_symbolize_keys
    @institutions = YAML::load_file(File.open(institutions_filename)).deep_symbolize_keys
    @institutions.each do |name, info|
      info[:username] = credentials[name][:username]
      info[:password] = credentials[name][:password]
    end
  end

  def run!
    output = ""
    net_worth = Money.new(0, "USD")

    @institutions.each do |name, info|
      institution = Institution.new(name,
                                    info[:username],
                                    info[:password],
                                    info[:login_page],
                                    info[:accounts_page])

      institution.fetch_accounts!

      output << "#{institution.name.upcase}\n"

      institution.accounts.each do |account|
        net_worth += account.balance
        sign = account.balance.negative? ? "-" : "+"
        amount = account.balance.abs.format.rjust(10)
        output << "#{sign}  #{amount}   #{account.name} [#{account.type}]\n"
      end
    end

    now = DateTime.now.strftime("%a %Y-%m-%d at %I:%M %p")

    output << "\n"
    output << "NET WORTH\n"
    output << "=  #{net_worth.format.rjust(10)} (as of #{now})\n"

    output
  end

end
