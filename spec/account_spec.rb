require "account"

RSpec.describe Account do
  let(:institution) { Institution.new(:acme_financial, "user", "pass") }
  let(:account) { Account.new(institution, "My Account", :checking) }

  it "pretty-prints" do
    expect(account.to_s).to eq("My Account (Acme Financial checking)")
  end
end
