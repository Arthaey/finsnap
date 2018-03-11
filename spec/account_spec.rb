require "account"

RSpec.describe Account do
  let(:account) { Account.new("My Account", :checking, 1234_00) }

  it "pretty-prints" do
    expect(account.to_s).to eq("My Account")
  end

  it "has a name" do
    expect(account.name).to eq("My Account")
  end

  it "has an account type" do
    expect(account.type).to eq(:checking)
  end

  it "has a balance" do
    expect(account.balance).to eq(Money.new(1234_00))
    expect(account.balance.format).to eq("$1,234.00")
  end
end
