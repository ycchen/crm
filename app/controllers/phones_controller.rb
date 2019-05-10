class PhonesController < ApplicationController

  before_action :authenticate_user!
  before_action :contact
  before_action :phone, except: [:new, :cancel_new, :create]

  def new
    @phone = Phone.new
  end

  def create
    @phone = @contact.phones.create(phone_params)
  end

  def update
    @phone.update_attributes(phone_params)
  end

  def edit; end

  def cancel_new; end

  def cancel_edit; end

  private

  def contact
    @contact = current_user.contacts.find_by(id: params[:contact_id])
    head :unauthorized unless @contact
  end

  def phone
    @phone = @contact.phones.find_by(id: params[:id]) if @contact
    head :unauthorized unless @phone
  end

  def phone_params
    params.require(:phone).permit(:phone_type_id, :number)
  end

end
