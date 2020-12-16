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
  describe 'merchants show' do
    it "can return one merchant by its id" do
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)
      merchant = json[:data][:attributes]

      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
    end
  end
  describe 'merchant create' do
    it "I can create a new merchant" do
      merchant_params = ({ name: "Trader Joes" })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/merchants", headers: headers, params: JSON.generate(merchant_params)
      created_merchant = Merchant.last

      expect(response).to be_successful
      expect(created_merchant.name).to eq(merchant_params[:name])
    end
  end
  describe 'merchants update' do
    it "can update an existing merchant" do
      id = create(:merchant).id
      previous_name = Merchant.last.name
      merchant_params = { name: "Costco" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/merchants/#{id}", headers: headers, params: JSON.generate(merchant_params)

      merchant = Merchant.find_by(id: id)

      expect(response).to be_successful
      expect(merchant.name).to_not eq(previous_name)
      expect(merchant.name).to eq(merchant_params[:name])
    end
  end
  describe 'merchants destroy' do
    it "I can destroy an merchant" do
      merchant = create(:merchant)

      expect(Merchant.count).to eq(1)
      expect{ delete "/api/v1/merchants/#{merchant.id}" }.to change(Merchant, :count).by(-1)
      expect(response).to be_successful
      expect{ Merchant.find(merchant.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
