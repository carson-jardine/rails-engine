class AddUnitPriceToInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    unless ActiveRecord::Base.connection.table_exists?('customers')
      add_column :invoice_items, :unit_price, :float
    end
  end
end
