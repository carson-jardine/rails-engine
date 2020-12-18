class Api::V1::Merchants::SearchController < ApplicationController

  def index
    search = Merchant.filter_from_params(params.slice(:name, :created_at, :updated_at))
      render json: MerchantSerializer.new(search)
  end

  def show
    search = Merchant.filter_from_params(params.slice(:name, :created_at, :updated_at))
      render json: MerchantSerializer.new(search[0])
  end
end
