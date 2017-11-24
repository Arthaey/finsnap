require "sources/umpqua"

RSpec.describe Umpqua do
  it_behaves_like 'a source', Umpqua.new
end
