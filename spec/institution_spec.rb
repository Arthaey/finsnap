require "institution"

RSpec.describe Institution do
  let(:institution) do
    Institution.new(:acme_financial, "user", "pass", "http://acme.example.com/login")
  end

  it "pretty-prints" do
    expect(institution.to_s).to eq("Acme Financial")
  end

  it "starts with no accounts" do
    expect(institution.accounts).to be_empty
  end

  it "has a key" do
    expect(institution.key).to eq(:acme_financial)
  end

  it "has a name" do
    expect(institution.name).to eq("Acme Financial")
  end

  it "fetches account from URL source" do
    institution.fetch_accounts!

    expect(institution.accounts.count).to eq(2)

    foo_account = institution.accounts[0]
    expect(foo_account.name).to eq("Foo")
    expect(foo_account.type).to eq(:checking)
    expect(foo_account.balance).to eq(Money.new(1234_00, "USD"))

    bar_account = institution.accounts[1]
    expect(bar_account.name).to eq("Bar")
    expect(bar_account.type).to eq(:credit)
    expect(bar_account.balance).to eq(Money.new(-3_14, "USD"))
  end

end
