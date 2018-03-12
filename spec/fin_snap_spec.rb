require "fin_snap"

ROOT_DIR = File.expand_path("../..", __FILE__)
INSTITUTIONS_FILE = "#{ROOT_DIR}/spec/fixtures/institutions.yml"
CREDENTIALS_FILE = "#{ROOT_DIR}/spec/fixtures/credentials.yml"

RSpec.describe FinSnap do
  let(:finsnap) { FinSnap.new(INSTITUTIONS_FILE, CREDENTIALS_FILE) }

  it "fetches and displays account balances" do
    FakeWeb.register_uri_with_filename("http://acme.example.com/login",
                                       "spec/fixtures/acme_login.html")

    FakeWeb.register_uri_with_filename("http://acme.example.com/accounts",
                                       "spec/fixtures/acme_accounts.html")

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
