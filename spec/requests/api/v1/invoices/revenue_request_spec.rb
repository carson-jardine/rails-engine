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
  it "returns the total revenue from all invoices between given dates" do
    start_date = Date.today - 80
    end_date = Date.today + 1

    get "/api/v1/revenue?start=#{start_date}&end=#{end_date}"

    expect(response).to be_successful

    revenue = JSON.parse(response.body, symbolize_names: true)
    
    expect(revenue).to have_key(:data)
    expect(revenue[:data]).to be_a(Hash)

    expect(revenue[:data]).to have_key(:attributes)
    expect(revenue[:data][:attributes]).to be_a(Hash)

    expect(revenue[:data][:attributes]).to have_key(:revenue)
    expect(revenue[:data][:attributes][:revenue]).to be_a(Float)
  end
end
