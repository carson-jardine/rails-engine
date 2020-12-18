class Api::V1::Invoices::RevenueController < ApplicationController
  def revenue_by_date_range
    start_date = params[:start_date]
    end_date = params[:end_date]
    render json: RevenueSerializer.revenue(Invoice.revenue_by_date_range(start_date, end_date))
  end
end
