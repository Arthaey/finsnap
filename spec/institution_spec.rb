require "institution"

RSpec.describe Institution do
  let(:institution) do
    Institution.new(:acme_financial, "user", "pass",
                    {
                      :url => "http://acme.example.com/login",
                      :form => "#login",
                      :username => "#username",
                      :password => "#password",
                    },
                    {
                      :account => ".account",
                      :name => ".name",
                      :type => ".type",
                      :balance => ".balance",
                    }
                   )
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

  it "fetches account from URL source (test 1)" do
    FakeWeb.register_uri(:get, "http://acme.example.com/login",
                         :body => File.read("spec/fixtures/acme_login.html"),
                         :content_type => "text/html")

    FakeWeb.register_uri(:post, "http://acme.example.com/accounts",
                         :body => File.read("spec/fixtures/acme_accounts.html"),
                         :content_type => "text/html")

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

  it "fetches account from URL source (test 2)" do
    FakeWeb.register_uri(:get, "http://foo.example.com/login",
                         :body => File.read("spec/fixtures/foo_login.html"),
                         :content_type => "text/html")

    FakeWeb.register_uri(:post, "http://foo.example.com/accounts",
                         :body => File.read("spec/fixtures/foo_accounts.html"),
                         :content_type => "text/html")

    foo_institution = Institution.new(:foo, "user", "pass", {
        :url => "http://foo.example.com/login",
        :form => "#foo-login",
        :username => "#foo-user",
        :password => "#foo-pass",
      },
      {
        :account => "tr",
        :name => ".foo-name",
        :type => ".foo-type",
        :balance => ".foo-balance",
      })

    foo_institution.fetch_accounts!

    expect(foo_institution.accounts.count).to eq(2)

    foo_account = foo_institution.accounts[0]
    expect(foo_account.name).to eq("Foo")
    expect(foo_account.type).to eq(:checking)
    expect(foo_account.balance).to eq(Money.new(1234_00, "USD"))

    bar_account = foo_institution.accounts[1]
    expect(bar_account.name).to eq("Bar")
    expect(bar_account.type).to eq(:credit)
    expect(bar_account.balance).to eq(Money.new(-3_14, "USD"))
  end

end
