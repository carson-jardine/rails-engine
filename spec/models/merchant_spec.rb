require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :invoices }
    it { should have_many :items }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'class methods' do
    before :each do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant)

      @item_1 = create(:item, unit_price: 17.00, merchant: @merchant_1)
      @item_2 = create(:item, unit_price: 17.00, merchant: @merchant_2)
      @item_3 = create(:item, unit_price: 11.00, merchant: @merchant_3)

      merchants = Merchant.all
      merchants.each do |merchant|
        5.times { create(:invoice, merchant: merchant) }
      end

      @merchant_1.invoices.each do |invoice|
        create(:invoice_item, invoice: invoice, item: @item_1, quantity: 10000000)
        create(:transaction, invoice: invoice)
      end

      @merchant_2.invoices.each do |invoice|
        create(:invoice_item, invoice: invoice, item: @item_2, quantity: 14)
        create(:transaction, invoice: invoice)
      end

      @merchant_3.invoices.each do |invoice|
        create(:invoice_item, invoice: invoice, item: @item_3, quantity: 145)
        create(:transaction, invoice: invoice)
      end
    end

    it ".most_revenue" do
      merchants = Merchant.most_revenue(3)
      expect(merchants).to eq([@merchant_1, @merchant_3, @merchant_2])

      merchants_2 = Merchant.most_revenue(2)
      expect(merchants_2).to eq([@merchant_1, @merchant_3])
      expect(merchants_2).to_not include(@merchant_2)
    end
  end
end
