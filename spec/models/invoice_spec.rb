require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should belong_to :merchant }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of :status }
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
      @invoice_1 = create(:invoice, merchant_id: @merchant_1.id, updated_at: '2020-08-22', status: 'shipped')
      @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, unit_price: 17.00, quantity: 10000000, updated_at: '2020-08-22',)
      create(:transaction, invoice: @invoice_1, result: 'success', updated_at: '2020-08-22',)

      @invoice_2 = create(:invoice, merchant_id: @merchant_2.id, updated_at: '2020-09-21', status: 'shipped')
      @invoice_item_2 =create(:invoice_item, invoice: @invoice_2, item: @item_2, unit_price: 17.00, quantity: 14, updated_at: '2020-09-21')
      create(:transaction, invoice: @invoice_2, result: 'success', updated_at: '2020-09-21')

      # merchant_2 invoices
      @invoice_3 = create(:invoice, merchant_id: @merchant_2.id, updated_at: '2020-07-02', status: 'shipped')
      @invoice_item_3 = create(:invoice_item, invoice: @invoice_3, item: @item_2, unit_price: 17.00, quantity: 14, updated_at: '2020-07-02')
      create(:transaction, invoice: @invoice_3, result: 'success', updated_at: '2020-07-02')

      # merchant_3 invoices
      @invoice_4 = create(:invoice, merchant_id: @merchant_3.id, updated_at: '2020-10-02', status: 'shipped')
      @invoice_item_4 = create(:invoice_item, invoice: @invoice_4, item: @item_3, unit_price: 11.00, quantity: 145, updated_at: '2020-10-02')
      create(:transaction, invoice: @invoice_4, result: 'success', updated_at: '2020-10-02')
    end
    it ".revenue_by_date_range" do
      start_date = '2020-08-22'
      end_date = '2020-12-19'
      
      aug_thru_dec_rev = (@invoice_item_1.unit_price * @invoice_item_1.quantity + @invoice_item_2.unit_price * @invoice_item_2.quantity + @invoice_item_4.unit_price * @invoice_item_4.quantity)

      revenue = Invoice.revenue_by_date_range(start_date, end_date)

      expect(revenue).to eq(aug_thru_dec_rev)
    end
  end
end
