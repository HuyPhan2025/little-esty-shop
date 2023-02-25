class Merchants::ItemsController < ApplicationController

  def index 
    @merchant = Merchant.find(params[:merchant_id])
    @items_for_specific_merchant = @merchant.items
    @items_with_disabled_status = Item.all.disabled_status_items(params)
    @items_with_enabled_status = Item.all.enabled_status_items(params)

    five_popular_items_variable = @merchant.items.five_popular_items

    @five_popular_items_hash = Hash.new

    five_popular_items_variable.each do |item| 
      # require 'pry'; binding.pry
      date = Invoice.most_transactions_date(item.id)
      @five_popular_items_hash[item] = [date.first.created_at, item.revenue_generated]
    end
  end

  def show
    @items = Item.all
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end
end