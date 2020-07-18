# frozen-string-literal: true

RSpec.describe Numo::OpenBLAS do
  it 'has a version number' do
    expect(Numo::OpenBLAS::VERSION).not_to be nil
  end
end
