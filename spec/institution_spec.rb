require "institution"

RSpec.describe Institution do
  let(:institution) { Institution.new(:acme_financial, "user", "pass") }

  it "pretty-prints" do
    expect(institution.to_s).to eq("Acme Financial")
  end

  it "has accounts" do
    expect(institution.accounts.count).to eq(2)
  end
end
