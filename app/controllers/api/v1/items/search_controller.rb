class Api::V1::Items::SearchController < ApplicationController

  def index
    search = Item.filter_from_params(params.slice(:name, :description, :unit_price, :created_at, :updated_at))
      render json: ItemSerializer.new(search)
  end

  def show
    search = Item.filter_from_params(params.slice(:name, :description, :unit_price, :created_at, :updated_at))
      render json: ItemSerializer.new(search[0])
  end
end
