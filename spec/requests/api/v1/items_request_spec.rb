require 'rails_helper'

describe 'Items API' do
  describe 'items index' do
    it "sends a list of items" do
      create_list(:item, 3)

      get '/api/v1/items'

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)
      items = json[:data]

      expect(items.count).to eq(3)

      items.each do |item|
        expect(item).to be_a(Hash)

        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)

        expect(item).to have_key(:attributes)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
      end
    end
  end
  describe 'items show' do
    it "can return one item by its id" do
      id = create(:item).id

      get "/api/v1/items/#{id}"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)
      item = json[:data][:attributes]

      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)
    end
  end
  describe 'items create' do
    it "I can create a new item" do
      merchant = create(:merchant)
      item_params = ({
        name: "Dinosaur Chicken Nuggets",
        description: "A very yummy treat that is definitely made for adults and not children",
        unit_price: 7.99,
        merchant_id: merchant.id
        })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item_params)
      created_item = Item.last

      expect(response).to be_successful
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(merchant.id)
    end
  end
  describe 'items update' do
    it "can update an existing item" do
      id = create(:item).id
      previous_unit_price = Item.last.unit_price
      item_params = { unit_price: 14.99 }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item_params)

      item = Item.find_by(id: id)

      expect(response).to be_successful
      expect(item.unit_price).to_not eq(previous_unit_price)
      expect(item.unit_price).to eq(item_params[:unit_price])
    end
  end
  describe 'items destroy' do
    it "I can destroy an item" do
      item = create(:item)

      expect(Item.count).to eq(1)
      expect{ delete "/api/v1/items/#{item.id}" }.to change(Item, :count).by(-1)
      expect(response).to be_successful
      expect{ Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
