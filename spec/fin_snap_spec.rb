require "fin_snap"

ROOT_DIR = File.expand_path("../..", __FILE__)
CONFIG_FILE = "#{ROOT_DIR}/spec/fixtures/sources.yml"

RSpec.describe FinSnap do
  let(:finsnap) { FinSnap.new(CONFIG_FILE) }

  it "fetches and displays account balances" do
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
