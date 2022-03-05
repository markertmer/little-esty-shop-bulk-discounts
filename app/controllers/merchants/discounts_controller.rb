class Merchants::DiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:id])
    @discounts = @merchant.discounts
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:discount_id])
  end
end
