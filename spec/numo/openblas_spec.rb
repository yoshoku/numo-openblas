# frozen-string-literal: true

RSpec.describe Numo::OpenBLAS do
  it 'has a library path' do
    expect(Numo::Linalg::Loader.libs).not_to be_nil
    expect(Numo::Linalg::Loader.libs.size).to eq(1)
    expect(Numo::Linalg::Loader.libs.first).to include('libopenblas')
  end

  it 'performs linear algebra computation' do
    a = Numo::DFloat.new(2, 4).rand
    c = a.dot(a.transpose)
    evl, evc = Numo::Linalg.eigh(c)
    d = evc.dot(evl.diag).dot(evc.transpose)
    err = Math.sqrt(((c - d)**2).sum)
    expect(err).to be <= 1e-10
  end
end
