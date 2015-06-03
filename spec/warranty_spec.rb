require 'warranty'

RSpec.describe Warranty do

  describe '#expiration_date' do

    context 'for IMEI with active warranty' do
      it 'returns the expiration date' do
        imei = '013977000323877'
        stub_request(:get, "selfsolve.apple.com/wcResults.do?sn=#{imei}&num=0").
          to_return(read_fixture(imei))

        warranty = Warranty.new(imei)
        expiration_date = Date.new(2015, 8, 10)
        expect(warranty.expiration_date).to eq(expiration_date)
      end
    end

  end

end
