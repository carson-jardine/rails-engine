require 'rails_helper'

describe 'Merchants Search API' do
  before :each do
    @merchant_1 = create(:merchant, name: 'Trader Joes')
    @merchant_2 = create(:merchant, name: 'Amazon')
    @merchant_3 = create(:merchant, name: 'Fat Joes', created_at: '2020-11-13', updated_at: '2020-12-14')
  end
  describe 'Single Find Endpoint' do

    it "sends one merchant that matches the search" do
      search = 'Trader'

      get "/api/v1/merchants/find?name=#{search}"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant).to be_a(Hash)

      expect(merchant).to have_key(:data)
      expect(merchant[:data]).to be_a(Hash)

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to be_a(String)
      expect(merchant[:data][:id]).to eq(@merchant_1.id.to_s)
      expect(merchant[:data][:id]).to_not eq(@merchant_2.id.to_s)

      expect(merchant[:data]).to have_key(:attributes)

      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
      expect(merchant[:data][:attributes][:name]).to eq(@merchant_1.name)
      expect(merchant[:data][:attributes][:name]).to include(search)
    end

    it "search is case insensitive" do
      search = 'trADer'

      get "/api/v1/merchants/find?name=#{search}"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant).to be_a(Hash)

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to eq(@merchant_1.id.to_s)
      expect(merchant[:data][:id]).to_not eq(@merchant_2.id.to_s)
      expect(merchant[:data][:id]).to_not eq(@merchant_3.id.to_s)

      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to eq(@merchant_1.name)
      expect(merchant[:data][:id]).to_not eq(@merchant_3.name)
    end

    it "search is partial" do
      search = 'tra'

      get "/api/v1/merchants/find?name=#{search}"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant).to be_a(Hash)

      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data][:id]).to eq(@merchant_1.id.to_s)
      expect(merchant[:data][:id]).to_not eq(@merchant_2.id.to_s)
      expect(merchant[:data][:id]).to_not eq(@merchant_3.id.to_s)

      expect(merchant[:data][:attributes]).to have_key(:name)
      expect(merchant[:data][:attributes][:name]).to eq(@merchant_1.name)
      expect(merchant[:data][:id]).to_not eq(@merchant_3.name)
    end

    describe "Find a merchant by timestamps" do

      it "created_at" do
        get "/api/v1/merchants/find?created_at=November+13"

        expect(response).to be_successful

        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(merchant).to be_a(Hash)

        expect(merchant).to have_key(:data)

        expect(merchant[:data]).to have_key(:id)
        expect(merchant[:data][:id]).to eq(@merchant_3.id.to_s)
        expect(merchant[:data][:id]).to_not eq(@merchant_1.id.to_s)

        expect(merchant[:data]).to have_key(:attributes)

        expect(merchant[:data][:attributes]).to have_key(:created_at)

        expect(merchant[:data][:attributes]).to have_key(:name)
        expect(merchant[:data][:attributes][:name]).to eq(@merchant_3.name)
        expect(merchant[:data][:attributes][:name]).to_not eq(@merchant_1.name)
        expect(merchant[:data][:attributes][:name]).to_not eq(@merchant_2.name)
      end

      it "updated_at" do
        updated_at = "2020-12-14"

        get "/api/v1/merchants/find?updated_at=#{updated_at}"

        expect(response).to be_successful

        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(merchant).to be_a(Hash)

        expect(merchant[:data]).to have_key(:id)
        expect(merchant[:data][:id]).to eq(@merchant_3.id.to_s)
        expect(merchant[:data][:id]).to_not eq(@merchant_1.id.to_s)

        expect(merchant[:data][:attributes]).to have_key(:updated_at)

        expect(merchant[:data][:attributes]).to have_key(:name)
        expect(merchant[:data][:attributes][:name]).to eq(@merchant_3.name)
        expect(merchant[:data][:attributes][:name]).to_not eq(@merchant_1.name)
        expect(merchant[:data][:attributes][:name]).to_not eq(@merchant_2.name)
      end
    end
  end

  describe 'Multi Find Endpoint' do
    it "sends array of merchants that match the search" do
      search = 'Joes'

      get "/api/v1/merchants/find_all?name=#{search}"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants).to be_a(Hash)
      expect(merchants).to have_key(:data)
      expect(merchants[:data]).to be_an(Array)
      expect(merchants[:data].count).to eq(2)

      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)

        expect(merchant).to have_key(:attributes)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to include(search)

        first_merchant = merchants[:data].first
        expect(first_merchant[:id]).to eq(@merchant_1.id.to_s)
        expect(first_merchant[:id]).to_not eq(@merchant_2.id.to_s)
        last_merchant = merchants[:data].last
        expect(last_merchant[:id]).to eq(@merchant_3.id.to_s)
        expect(last_merchant[:id]).to_not eq(@merchant_2.id.to_s)
      end
    end

    it "search is case insensitive" do
      search = 'joEs'

      get "/api/v1/merchants/find_all?name=#{search}"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants).to be_a(Hash)
      expect(merchants[:data].count).to eq(2)

      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)

        expect(merchant).to have_key(:attributes)

        expect(merchant[:attributes]).to have_key(:name)

        first_merchant = merchants[:data].first
        expect(first_merchant[:id]).to eq(@merchant_1.id.to_s)
        expect(first_merchant[:id]).to_not eq(@merchant_2.id.to_s)
      end
    end

    it "search is partial" do
      search = 'jo'

      get "/api/v1/merchants/find_all?name=#{search}"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants).to be_a(Hash)
      expect(merchants[:data].count).to eq(2)

      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)

        expect(merchant).to have_key(:attributes)

        expect(merchant[:attributes]).to have_key(:name)

        first_merchant = merchants[:data].first
        expect(first_merchant[:id]).to eq(@merchant_1.id.to_s)
        expect(first_merchant[:id]).to_not eq(@merchant_2.id.to_s)
      end
    end

    describe "Find a merchant by timestamps" do
      before :each do
        @merchant_4 = create(:merchant, name: "Sleepy", created_at: '2020-11-13', updated_at: '2020-12-14')
      end
      it "created_at" do

        get "/api/v1/merchants/find_all?created_at=November+13"

        expect(response).to be_successful

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants).to be_a(Hash)
        expect(merchants[:data].count).to eq(2)

        merchants[:data].each do |merchant|
          expect(merchant).to have_key(:id)
          expect(merchant[:id]).to be_a(String)

          expect(merchant).to have_key(:attributes)

          expect(merchant[:attributes]).to have_key(:created_at)

          first_merchant = merchants[:data].first
          expect(first_merchant[:id]).to eq(@merchant_3.id.to_s)
          expect(first_merchant[:id]).to_not eq(@merchant_2.id.to_s)

          last_merchant = merchants[:data].last
          expect(last_merchant[:id]).to eq(@merchant_4.id.to_s)
        end
      end

      it "updated_at" do
        updated_at = "2020-12-14"

        get "/api/v1/merchants/find_all?updated_at=#{updated_at}"

        expect(response).to be_successful

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants).to be_a(Hash)
        expect(merchants[:data].count).to eq(2)

        merchants[:data].each do |merchant|
          expect(merchant).to have_key(:id)
          expect(merchant[:id]).to be_a(String)

          expect(merchant).to have_key(:attributes)

          expect(merchant[:attributes]).to have_key(:updated_at)

          first_merchant = merchants[:data].first
          expect(first_merchant[:id]).to eq(@merchant_3.id.to_s)
          expect(first_merchant[:id]).to_not eq(@merchant_2.id.to_s)

          last_merchant = merchants[:data].last
          expect(last_merchant[:id]).to eq(@merchant_4.id.to_s)
        end
      end
    end
  end
end
