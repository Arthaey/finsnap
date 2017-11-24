require "yaml"

require "extensions/object"
require "institution"

class FinSnap
  def initialize(config_filename)
    config = YAML::load_file(File.open(config_filename)).deep_symbolize_keys
    @sources = config[:sources]
  end

  def run!
    accounts = []

    @sources.each do |name, info|
      institution = Institution.login(name, info[:username], info[:password])
      accounts.push(*institution.accounts)
    end

    puts accounts # DELETE ME
  end
end
