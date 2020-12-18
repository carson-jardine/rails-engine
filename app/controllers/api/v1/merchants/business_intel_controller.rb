class Api::V1::Merchants::BusinessIntelController < ApplicationController
  def most_revenue
    merchants = Merchant.most_revenue(params[:quantity])
    render json: MerchantSerializer.new(merchants)
  end

  def most_items
    merchants = Merchant.most_items(params[:quantity])
    render json: MerchantSerializer.new(merchants)
  end
end
