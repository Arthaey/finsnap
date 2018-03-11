require "institution"

RSpec.describe Institution do
  context "defaults" do
    let(:institution) { Institution.new(:acme_financial, "user", "pass") }

    it "starts with no accounts" do
      expect(institution.accounts).to be_empty
    end

    it "has a key" do
      expect(institution.key).to eq(:acme_financial)
    end

    it "has a name" do
      expect(institution.name).to eq("Acme Financial")
    end

    it "returns no accounts when no page selectors are given" do
      institution.fetch_accounts!
      expect(institution.accounts).to be_empty
    end

    it "pretty-prints" do
      expect(institution.to_s).to eq("Acme Financial")
    end
  end

  it "fetches accounts from user-provided CSS selector" do
    FakeWeb.register_uri_with_html("http://foo.example.com/login", <<~LOGIN_HTML
        <form id="foo-login" action="/accounts" method="post">
          <input type="text" name="foo-user" id="foo-user" />
          <input type="text" name="foo-pass" id="foo-pass" />
          <input type="submit" name="foo-login" id="foo-login" value="Log In" />
        </form>
      LOGIN_HTML
    )

    FakeWeb.register_uri_with_html("http://foo.example.com/accounts", <<~ACCOUNTS_HTML
        <table>
          <tr>
            <td class="foo-name">ChkA</td>
            <td class="foo-type">checking</td>
            <td class="foo-balance">$1,234.00</td>
          </tr>
          <tr>
            <td class="foo-name">CrB</td>
            <td class="foo-type">credit</td>
            <td class="foo-balance">$-3.14</td>
          </tr>
        </table>
      ACCOUNTS_HTML
    )

    foo_institution = Institution.new(:foo, "user", "pass",
      {
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

    expect(foo_institution.name).to eq("Foo")
    expect(foo_institution.accounts.count).to eq(2)

    foo_account = foo_institution.accounts[0]
    expect(foo_account.name).to eq("ChkA")
    expect(foo_account.type).to eq(:checking)
    expect(foo_account.balance).to eq(Money.new(1234_00, "USD"))

    bar_account = foo_institution.accounts[1]
    expect(bar_account.name).to eq("CrB")
    expect(bar_account.type).to eq(:credit)
    expect(bar_account.balance).to eq(Money.new(-3_14, "USD"))
  end

end
