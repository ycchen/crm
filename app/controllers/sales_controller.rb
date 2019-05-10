class SalesController < ApplicationController

  before_action :authenticate_user!
  before_action :contact, only: [:index]
  before_action :sale, only: [:update]

  def index
    if @contact
      @sales = @contact.sales
    else
      @sales = current_user.sales
    end
    @sales = @sales.ordered.includes([:sale_items, :contact]).paginate(page: params[:page], per_page: 25)
  end

  def new
    @sale = Sale.new
  end

  def create
    @contact = current_user.contacts.find_by(id: sale_params[:contact_id])
    if @contact
      @sale = current_user.sales.create(contact_id: @contact.id)
      redirect_to sale_sale_items_path(@sale)
    else
      render :new
    end
  end

  def update
    @errors = FieldValue.update_values(current_user, @sale, custom_fields_params)
    if @errors.empty?
      redirect_to sale_sale_items_path(@sale)
    else
      @sale_item = SaleItem.new
      render 'sale_items/index'
    end
  end

  private

  def sale
    @sale = current_user.sales.find_by(id: params[:id])
  end

  def contact
    @contact = current_user.contacts.find_by(id: params[:contact_id])
  end

  def sale_params
    params.require(:sale).permit(:contact_id)
  end

  def custom_fields_params
    params.require(:custom_fields).permit!
  end

end
