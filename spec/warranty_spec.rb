require 'warranty'

RSpec.describe Warranty do

  describe '#expiration_date' do

    context 'for IMEI with active warranty' do
      before do
        @imei = '013977000323877'
        stub_request(:get, "https://selfsolve.apple.com/wcResults.do"\
          "?sn=#{@imei}&num=0").to_return(read_fixture(@imei))
      end

      it 'returns the expiration date' do
        warranty = Warranty.new(@imei)
        expiration_date = Date.new(2016, 8, 10)

        expect(warranty.expiration_date).to eq(expiration_date)
      end
    end

    context 'for IMEI with expired warranty' do
      before do
        @imei = '013896000639712'
        stub_request(:get, "https://selfsolve.apple.com/wcResults.do"\
          "?sn=#{@imei}&num=0").to_return(read_fixture(@imei))
      end

      it 'returns nil' do
        warranty = Warranty.new(@imei)

        expect(warranty.expiration_date).to be(nil)
      end
    end

    context 'for IMEI with no information' do
      before do
        @imei = '013977000323'
        stub_request(:get, "https://selfsolve.apple.com/wcResults.do"\
          "?sn=#{@imei}&num=0").to_return(read_fixture(@imei))
      end

      it 'returns LookupError' do
        warranty = Warranty.new(@imei)
        expect { warranty.expiration_date }.to raise_error(LookupError)
      end
    end

  end

end
