ROOT_DIR = File.expand_path("../..", __FILE__)

RSpec.describe "finsnap command" do
  command "#{ROOT_DIR}/finsnap #{ROOT_DIR}/spec/fixtures/sources.yml"

  its(:stdout) { is_expected.to include("Foo (Acme Financial checking)") }
  its(:stdout) { is_expected.to include("Bar (Acme Financial saving)") }
end
