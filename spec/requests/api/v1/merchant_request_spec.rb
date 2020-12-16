require 'rails_helper'

describe 'Merchant API' do
  describe 'merchants index' do
    it "sends a list of merchants" do
      create_list(:merchant, 13)

      get '/api/v1/merchants'

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)
      merchants = json[:data]

      expect(merchants.count).to eq(13)

      merchants.each do |merchant|
        expect(merchant).to be_a(Hash)

        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)

        expect(merchant).to have_key(:attributes)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end
  end
end
