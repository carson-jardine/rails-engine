class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def create
    merchant = Merchant.create(merchant_params)
    render json: MerchantSerializer.new(merchant)
  end

  def update
    merchant = Merchant.update(params[:id], merchant_params)
    render json: MerchantSerializer.new(merchant)
  end

  def destroy
    Merchant.destroy(params[:id])
  end

  private

  def merchant_params
    params.permit(:name)
  end
end
