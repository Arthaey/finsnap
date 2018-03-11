require "date"

ROOT_DIR = File.expand_path("../..", __FILE__)
FINSNAP = "#{ROOT_DIR}/finsnap"
CONFIG_FILE = "#{ROOT_DIR}/spec/fixtures/sources.yml"

RSpec.describe "finsnap command" do

  command "#{FINSNAP} #{CONFIG_FILE}"

  its(:stdout) { is_expected.to include("LOGIN Acme Financial as acme_user") }

  its(:stdout) do
    output = <<~OUTPUT
      ACME FINANCIAL
      +   $1,234.00   Foo [checking]
      -       $3.14   Bar [credit]

      NET WORTH
      =   $1,230.86
    OUTPUT

    is_expected.to include output.strip
  end

end
