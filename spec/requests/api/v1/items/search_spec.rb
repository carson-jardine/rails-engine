require 'rails_helper'

describe 'Items Search API' do
  before :each do
    @item_1 = create(:item, name: 'Hair Brush', created_at: '2020-08-22', updated_at: '2020-12-14')
    @item_2 = create(:item, name: 'Hair Tie', description: 'Leave me on your wrist and make every picture ugly!', unit_price: 17.99)
    @item_3 = create(:item, name: 'Balloon', description: 'Make every child happy!', unit_price: 17.99)
  end
  describe 'Single Find Endpoint' do
    describe "can send one match based on..." do
      it 'name' do
        search = 'Hair'

        get "/api/v1/items/find?name=#{search}"

        expect(response).to be_successful

        item = JSON.parse(response.body, symbolize_names: true)
        expect(item).to be_a(Hash)

        expect(item).to have_key(:data)
        expect(item[:data]).to be_a(Hash)

        expect(item[:data]).to have_key(:id)
        expect(item[:data][:id]).to be_a(String)
        expect(item[:data][:id]).to eq(@item_1.id.to_s)
        expect(item[:data][:id]).to_not eq(@item_2.id.to_s)

        expect(item[:data]).to have_key(:attributes)

        expect(item[:data][:attributes]).to have_key(:name)
        expect(item[:data][:attributes][:name]).to be_a(String)
        expect(item[:data][:attributes][:name]).to eq(@item_1.name)
        expect(item[:data][:attributes][:name]).to include(search)

        expect(item[:data][:attributes]).to have_key(:name)
        expect(item[:data][:attributes]).to have_key(:description)
        expect(item[:data][:attributes]).to have_key(:unit_price)
        expect(item[:data][:attributes]).to have_key(:created_at)
        expect(item[:data][:attributes]).to have_key(:updated_at)
      end
      it 'description' do
        search = 'make every'

        get "/api/v1/items/find?description=#{search}"

        expect(response).to be_successful

        item = JSON.parse(response.body, symbolize_names: true)
        expect(item).to be_a(Hash)

        expect(item).to have_key(:data)
        expect(item[:data]).to be_a(Hash)

        expect(item[:data][:id]).to eq(@item_2.id.to_s)
        expect(item[:data][:id]).to_not eq(@item_3.id.to_s)

        expect(item[:data][:attributes][:description]).to eq(@item_2.description)
      end

      it 'unit_price' do
        search = '17.99'

        get "/api/v1/items/find?unit_price=#{search}"

        expect(response).to be_successful

        item = JSON.parse(response.body, symbolize_names: true)

        expect(item).to be_a(Hash)

        expect(item).to have_key(:data)
        expect(item[:data]).to be_a(Hash)

        expect(item[:data][:id]).to eq(@item_2.id.to_s)
        expect(item[:data][:id]).to_not eq(@item_3.id.to_s)

        expect(item[:data][:attributes][:unit_price]).to eq(@item_2.unit_price)
      end
    end
    it "search is case insensitive" do
      search = 'hAiR'

      get "/api/v1/items/find?name=#{search}"

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)
      expect(item).to be_a(Hash)

      expect(item).to have_key(:data)

      expect(item[:data]).to have_key(:id)

      expect(item[:data][:id]).to eq(@item_1.id.to_s)
      expect(item[:data][:id]).to_not eq(@item_2.id.to_s)
      expect(item[:data][:attributes][:name]).to eq(@item_1.name)
    end
    it "search is partial" do
      search = 'ha'

      get "/api/v1/items/find?name=#{search}"

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)
      expect(item).to be_a(Hash)

      expect(item).to have_key(:data)

      expect(item[:data]).to have_key(:id)

      expect(item[:data][:id]).to eq(@item_1.id.to_s)
      expect(item[:data][:id]).to_not eq(@item_2.id.to_s)
    end
    describe "Find a item by timestamps" do

      it "created_at" do
        created_at = '2020-08-22'

        get "/api/v1/items/find?created_at=#{created_at}"

        expect(response).to be_successful

        item = JSON.parse(response.body, symbolize_names: true)
        expect(item).to be_a(Hash)

        expect(item).to have_key(:data)

        expect(item[:data]).to have_key(:id)

        expect(item[:data][:id]).to eq(@item_1.id.to_s)
        expect(item[:data][:id]).to_not eq(@item_2.id.to_s)
      end

      it "updated_at" do
        get "/api/v1/items/find?updated_at=December+14"

        expect(response).to be_successful

        item = JSON.parse(response.body, symbolize_names: true)
        expect(item).to be_a(Hash)

        expect(item).to have_key(:data)

        expect(item[:data]).to have_key(:id)

        expect(item[:data][:id]).to eq(@item_1.id.to_s)
        expect(item[:data][:id]).to_not eq(@item_2.id.to_s)
      end
    end
  end

  describe 'Multi Find Endpoint' do
    describe "can send an array of matches based on..." do
      it 'name' do
        search = 'Hair'

        get "/api/v1/items/find_all?name=#{search}"

        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)
        expect(items).to be_a(Hash)
        expect(items).to have_key(:data)
        expect(items[:data].count).to eq(2)

        items[:data].each do |item|
          expect(item).to have_key(:id)

          expect(item).to have_key(:attributes)

          expect(item[:attributes]).to have_key(:name)
          expect(item[:attributes][:name]).to include(search)

          first_item = items[:data].first
          expect(first_item[:id]).to eq(@item_1.id.to_s)
          expect(first_item[:id]).to_not eq(@item_3.id.to_s)

          last_item = items[:data].last
          expect(last_item[:id]).to eq(@item_2.id.to_s)
        end
      end
      it 'description' do
        search = 'make every'

        get "/api/v1/items/find_all?description=#{search}"

        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)
        expect(items).to be_a(Hash)

        expect(items).to have_key(:data)
        expect(items[:data]).to be_an(Array)
        expect(items[:data].count).to eq(2)

        items[:data].each do |item|
          expect(item).to have_key(:id)

          expect(item).to have_key(:attributes)

          expect(item[:attributes]).to have_key(:description)
          expect(item[:attributes][:description].downcase).to include(search)

          first_item = items[:data].first
          expect(first_item[:id]).to eq(@item_2.id.to_s)
          expect(first_item[:id]).to_not eq(@item_1.id.to_s)

          last_item = items[:data].last
          expect(last_item[:id]).to eq(@item_3.id.to_s)
        end
      end

      it 'unit_price' do
        search = '17.99'

        get "/api/v1/items/find_all?unit_price=#{search}"

        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)
        expect(items).to be_a(Hash)

        expect(items).to have_key(:data)
        expect(items[:data]).to be_an(Array)
        expect(items[:data].count).to eq(2)

        items[:data].each do |item|
          expect(item).to have_key(:id)

          expect(item).to have_key(:attributes)

          expect(item[:attributes]).to have_key(:unit_price)
          expect(item[:attributes][:unit_price]).to eq(search.to_f)

          first_item = items[:data].first
          expect(first_item[:id]).to eq(@item_2.id.to_s)
          expect(first_item[:id]).to_not eq(@item_1.id.to_s)

          last_item = items[:data].last
          expect(last_item[:id]).to eq(@item_3.id.to_s)
        end
      end
    end
    it "search is case insensitive" do
      search = 'hAiR'

      get "/api/v1/items/find_all?name=#{search}"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)
      expect(items[:data].count).to eq(2)

      first_item = items[:data].first
      expect(first_item[:id]).to eq(@item_1.id.to_s)
      expect(first_item[:id]).to_not eq(@item_3.id.to_s)

      last_item = items[:data].last
      expect(last_item[:id]).to eq(@item_2.id.to_s)
    end
    it "search is partial" do
      search = 'ha'

      get "/api/v1/items/find_all?name=#{search}"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)
      expect(items[:data].count).to eq(2)

      first_item = items[:data].first
      expect(first_item[:id]).to eq(@item_1.id.to_s)
      expect(first_item[:id]).to_not eq(@item_3.id.to_s)

      last_item = items[:data].last
      expect(last_item[:id]).to eq(@item_2.id.to_s)
    end
    describe "Find a item by timestamps" do
      before :each do
        @item_4 = create(:item, created_at: '2020-08-22', updated_at: '2020-12-14' )
      end
      it "created_at" do
        created_at = '2020-08-22'

        get "/api/v1/items/find_all?created_at=#{created_at}"

        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)
        expect(items[:data].count).to eq(2)

        first_item = items[:data].first
        expect(first_item[:id]).to eq(@item_1.id.to_s)
        expect(first_item[:id]).to_not eq(@item_3.id.to_s)

        last_item = items[:data].last
        expect(last_item[:id]).to eq(@item_4.id.to_s)
      end

      it "updated_at" do
        get "/api/v1/items/find_all?updated_at=December+14"

        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)
        expect(items[:data].count).to eq(2)

        first_item = items[:data].first
        expect(first_item[:id]).to eq(@item_1.id.to_s)
        expect(first_item[:id]).to_not eq(@item_3.id.to_s)

        last_item = items[:data].last
        expect(last_item[:id]).to eq(@item_4.id.to_s)
      end
    end
  end
end
