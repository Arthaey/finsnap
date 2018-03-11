require "fin_snap"

ROOT_DIR = File.expand_path("../..", __FILE__)
CONFIG_FILE = "#{ROOT_DIR}/spec/fixtures/sources.yml"

RSpec.describe FinSnap do
  let(:finsnap) { FinSnap.new(CONFIG_FILE) }

  it "fetches and displays account balances" do
    FakeWeb.register_uri(:get, "http://acme.example.com/login",
                         :body => File.read("spec/fixtures/acme_login.html"),
                         :content_type => "text/html")

    FakeWeb.register_uri(:post, "http://acme.example.com/accounts",
                         :body => File.read("spec/fixtures/acme_accounts.html"),
                         :content_type => "text/html")

    actual_output = finsnap.run!

    expected_output = <<~OUTPUT
      ACME FINANCIAL
      +   $1,234.00   Foo [checking]
      -       $3.14   Bar [credit]

      NET WORTH
      =   $1,230.86
    OUTPUT

    expect(actual_output).to include(expected_output.strip)
  end
end
