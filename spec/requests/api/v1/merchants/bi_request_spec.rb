require 'rails_helper'

describe 'Merchants Business Intelligence API' do
  before :each do
    @merchant_1 = create(:merchant, name: 'Trader Joes')
    @merchant_2 = create(:merchant, name: 'Amazon')
    @merchant_3 = create(:merchant, name: 'Fat Joes')

    @item_1 = create(:item, unit_price: 1050.00, merchant: @merchant_1)
    @item_2 = create(:item, unit_price: 17.00, merchant: @merchant_2)
    @item_3 = create(:item, unit_price: 11.30, merchant: @merchant_3)

    merchants = Merchant.all
    merchants.each do |merchant|
      5.times { create(:invoice, merchant: merchant) }
    end

    @merchant_1.invoices.each do |invoice|
      create(:invoice_item, invoice: invoice, item: @item_1, unit_price: 1050.00, quantity: 100)
      create(:transaction, invoice: invoice)
    end

    @merchant_2.invoices.each do |invoice|
      create(:invoice_item, invoice: invoice, item: @item_2, unit_price: 17.00, quantity: 145)
      create(:transaction, invoice: invoice)
    end

    @merchant_3.invoices.each do |invoice|
      create(:invoice_item, invoice: invoice, item: @item_3, unit_price: 11.30, quantity: 10)
      create(:transaction, invoice: invoice)
    end
  end
  it 'returns array of merchants sorted by most revenue' do
    get '/api/v1/merchants/most_revenue?quantity=3'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants).to be_a(Hash)
    expect(merchants).to have_key(:data)
    expect(merchants[:data]).to be_an(Array)

    expect(merchants[:data][0]).to have_key(:id)
    expect(merchants[:data][0][:id]).to eq(@merchant_1.id.to_s)
    expect(merchants[:data][0]).to have_key(:attributes)

    expect(merchants[:data][0][:attributes]).to have_key(:name)
    expect(merchants[:data][0][:attributes][:name]).to eq(@merchant_1.name)
  end
  it "returns an array of merchants sorted by most items sold" do
    get '/api/v1/merchants/most_items?quantity=3'
    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    expect(merchants).to be_a(Hash)
    expect(merchants).to have_key(:data)
    expect(merchants[:data]).to be_an(Array)

    expect(merchants[:data][0]).to have_key(:id)
    expect(merchants[:data][0]).to have_key(:attributes)

    expect(merchants[:data][0][:attributes]).to have_key(:name)
    expect(merchants[:data][0][:attributes][:name]).to eq(@merchant_2.name)
  end
  it "returns the total revenue from all merchants between given dates" do

  end
end
