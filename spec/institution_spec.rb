require "institution"

RSpec.describe Institution do
  let(:institution) { Institution.new(:acme_financial, "user", "pass") }

  it "pretty-prints" do
    expect(institution.to_s).to eq("Acme Financial")
  end

  it "has accounts" do
    expect(institution.accounts.count).to eq(2)
  end

  it "has a key" do
    expect(institution.key).to eq(:acme_financial)
  end

  it "has a name" do
    expect(institution.name).to eq("Acme Financial")
  end

  it "logs in" do
    source = instance_double("Source", :acme_financial)
    institution.login!
  end

end
