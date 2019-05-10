class ProductsController < ApplicationController

  before_action :authenticate_user!
  before_action :product, only: [:edit, :update]

  def index
    @products = current_user.products.ordered.paginate(page: params[:page], per_page: 10)
  end

  def new
    @product = current_user.products.new
  end

  def create
    @product = current_user.products.create(product_params)
    if @product.persisted?
      @errors = FieldValue.update_values(current_user, @product, custom_fields_params)
      if @errors.empty?
        redirect_to products_path
      else
        redirect_to edit_product_path(@product)
      end
    else
      render :new
    end
  end

  def edit
    redirect_to products_path unless @product
  end

  def update
    if @product
      @product.update_attributes(product_params)
      @errors = FieldValue.update_values(current_user, @product, custom_fields_params)
      if @product.errors.empty? && @errors.empty?
        redirect_to edit_product_path(@product)
      else
        render :edit
      end
    else
      redirect_to products_path
    end
  end

  def autocomplete
    return [] unless search_params[:query]
    t = Product.arel_table
    query = search_params[:query].downcase
    products = current_user.products.where(t[:name].matches("#{query}%")).order(:name)
    @products = products.collect { |p| { value: p.name, data: p.id, price: format('%.2f', p.price) } }
  end

  private

  def product
    @product = current_user.products.find_by(id: params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :desc, :price, :img)
  end

  def custom_fields_params
    if params[:custom_fields]
      params.require(:custom_fields).permit!
    else
      []
    end
  end

  def search_params
    params.permit(:query)
  end
end
