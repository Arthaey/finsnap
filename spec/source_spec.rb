require "source"

RSpec.shared_examples 'a source' do
  let(:source) { described_class.new }

  describe "defines methods" do
    it "#login" do
      expect(source).to respond_to(:login)
    end

    it "#accounts" do
      expect(source).to respond_to(:accounts)
    end

    it "#account" do
      expect(source).to respond_to(:account)
    end
  end
end
