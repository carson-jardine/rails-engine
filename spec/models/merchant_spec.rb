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

      # merchant_1 invoices
      @invoice_1 = create(:invoice, merchant_id: @merchant_1.id, created_at: '2020-08-22', status: 'shipped')
      @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, unit_price: 17.00, quantity: 10000000, created_at: '2020-08-22',)
      create(:transaction, invoice: @invoice_1, result: 'success', created_at: '2020-08-22',)

      @invoice_2 = create(:invoice, merchant_id: @merchant_2.id, created_at: '2020-09-21', status: 'shipped')
      @invoice_item_2 =create(:invoice_item, invoice: @invoice_2, item: @item_2, unit_price: 17.00, quantity: 14, created_at: '2020-09-21')
      create(:transaction, invoice: @invoice_2, result: 'success', created_at: '2020-09-21')

      # merchant_2 invoices
      @invoice_3 = create(:invoice, merchant_id: @merchant_2.id, created_at: '2020-07-02', status: 'shipped')
      @invoice_item_3 = create(:invoice_item, invoice: @invoice_3, item: @item_2, unit_price: 17.00, quantity: 14, created_at: '2020-07-02')
      create(:transaction, invoice: @invoice_3, result: 'success', created_at: '2020-07-02')

      # merchant_3 invoices
      @invoice_4 = create(:invoice, merchant_id: @merchant_3.id, created_at: '2020-10-02', status: 'shipped')
      @invoice_item_4 = create(:invoice_item, invoice: @invoice_4, item: @item_3, unit_price: 11.00, quantity: 145, created_at: '2020-10-02')
      create(:transaction, invoice: @invoice_4, result: 'success', created_at: '2020-10-02')

    end

    it ".most_revenue" do
      merchants = Merchant.most_revenue(3)
      expect(merchants).to eq([@merchant_1, @merchant_3, @merchant_2])

      merchants_2 = Merchant.most_revenue(2)
      expect(merchants_2).to eq([@merchant_1, @merchant_3])
      expect(merchants_2).to_not include(@merchant_2)
    end

    it ".most_items" do
      merchants = Merchant.most_items(3)
      expect(merchants).to eq([@merchant_1, @merchant_3, @merchant_2])

      merchants_2 = Merchant.most_items(2)
      expect(merchants_2).to eq([@merchant_1, @merchant_3])
      expect(merchants_2).to_not include(@merchant_2)
    end
  end
end
