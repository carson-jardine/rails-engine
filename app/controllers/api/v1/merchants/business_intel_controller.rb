class Api::V1::Merchants::BusinessIntelController < ApplicationController
  def most_revenue
    merchants = Merchant.most_revenue(params[:quantity])
    render json: MerchantSerializer.new(merchants)
  end

  def most_items
    merchants = Merchant.most_items(params[:quantity])
    render json: MerchantSerializer.new(merchants)
  end

  # def revenue_by_date_range
  #   start_date = params[:start]
  #   end_date = params[:end]
  #   json_response(RevenueSerializer.revenue(Invoice.revenue_by_dates(start_date, end_date)))
  # end
end
