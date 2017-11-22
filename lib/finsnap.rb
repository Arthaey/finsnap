#!/usr/bin/env ruby
require "yaml"

require_relative "extensions/object"
require_relative "extensions/string"

require_relative "institution"

config = YAML::load_file(File.open("sources.yml")).deep_symbolize_keys

sources = config[:sources]
accounts = []

sources.each do |name, info|
  institution = Institution.login(name, info[:username], info[:password])
  accounts.push(*institution.accounts)
end

puts accounts # DELETE ME
