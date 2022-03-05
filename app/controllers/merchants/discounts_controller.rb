class Merchants::DiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:id])
    @discounts = @merchant.discounts
  end

  def show
    # binding.pry
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:discount_id])
  end

  def new
    @merchant = Merchant.find(params[:id])
  end

  def create
    merchant = Merchant.find(params[:id])
    discount = merchant.discounts.new(discount_params)

    if discount.save
      redirect_to "/merchants/#{merchant.id}/discounts"
    else
      redirect_to "/merchants/#{merchant.id}/discounts/new"
      flash[:alert] = "Error: #{error_message(discount.errors)}"
    end
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:discount_id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    discount = Discount.find(params[:discount_id])

    if discount.update(discount_params)
      redirect_to "/merchants/#{merchant.id}/discounts/#{discount.id}"
    else
      redirect_to "/merchants/#{merchant.id}/discounts/#{discount.id}/edit"
      flash[:alert] = "Error: #{error_message(discount.errors)}"
    end
  end

  def destroy
    Discount.find(params[:discount_id]).destroy
    redirect_to "/merchants/#{params[:merchant_id]}/discounts"
  end

  private
    def discount_params
      params.permit(:name, :percent, :threshold)
    end

end
