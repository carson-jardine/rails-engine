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
  describe 'merchant items' do
    before :each do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)

      5.times do
        create(:item, merchant: @merchant_1)
      end

    end
    it "sends all items for a specific merchant" do
      get "/api/v1/merchants/#{@merchant_1.id}/items"

      expect(response).to be_successful

      merchant_items = JSON.parse(response.body, symbolize_names: true)
      items = merchant_items[:data]

      expect(items.count).to eq(5)

      items.each do |item|
        expect(item).to be_a(Hash)

        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)

        expect(item).to have_key(:type)
        expect(item[:type]).to be_a(String)
        expect(items.first[:type]).to eq('item')

        expect(item).to have_key(:attributes)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to eq(@merchant_1.id)
        expect(item[:attributes][:merchant_id]).to_not eq(@merchant_2.id)
      end
    end
    it "does not send other merchant's items" do
      create(:item, merchant: @merchant_2)

      get "/api/v1/merchants/#{@merchant_2.id}/items"

      merchant_items = JSON.parse(response.body, symbolize_names: true)
      items = merchant_items[:data]

      expect(items.count).to eq(1)
      expect(items.count).to_not eq(5)

      items.each do |item|
        expect(item[:attributes][:merchant_id]).to eq(@merchant_2.id)
        expect(item[:attributes][:merchant_id]).to_not eq(@merchant_1.id)
      end
    end
  end
end
