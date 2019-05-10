class SaleItemsController < ApplicationController

  before_action :authenticate_user!
  before_action :sale, only: [:index, :create, :destroy]

  def index
    if @sale
      @sale_items = @sale.sale_items
      @sale_item = SaleItem.new
      @custom_fields = current_user.custom_fields.for_entity(EntityType.sale).ordered
    else
      redirect_to sales_path
    end
  end

  def create
    if @sale
      @sale_item = @sale.sale_items.create(sale_item_params)
      redirect_to sale_sale_items_path(@sale)
    else
      redirect_to sales_path
    end
  end

  def destroy
    if @sale
      @sale_item = @sale.sale_items.find_by(id: params[:id])
      @sale_item.destroy if @sale_item
      redirect_to sale_sale_items_path(@sale)
    else
      redirect_to sales_path
    end
  end

  private

  def sale
    @sale = current_user.sales.find_by(id: params[:sale_id])
  end

  def sale_item_params
    params.require(:sale_item).permit(:product_id, :quantity, :price)
  end

end
