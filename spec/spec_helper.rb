require "fakeweb"

FakeWeb.allow_net_connect = false

login_html = File.read("spec/fixtures/acme_login.html")
FakeWeb.register_uri(:get, "http://acme.example.com/login",
                     :body => login_html,
                     :content_type => "text/html")

accounts_html = File.read("spec/fixtures/acme_accounts.html")
FakeWeb.register_uri(:post, "http://acme.example.com/accounts",
                     :body => accounts_html,
                     :content_type => "text/html")


# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus # fit, fdescribe, fcontext, and :focus tag
  config.order = :random
  config.warnings = false

  #config.profile_examples = 10
end
