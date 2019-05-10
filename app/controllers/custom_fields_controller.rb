class CustomFieldsController < ApplicationController

  before_action :authenticate_user!
  before_action :custom_field, only: [:edit, :update]

  def index
    @custom_fields = current_user.custom_fields.ordered.includes([:field_type, :entity_type])
  end

  def new
    @custom_field = CustomField.new
  end

  def create
    @custom_field = current_user.custom_fields.create(custom_field_params)
    if @custom_field.persisted?
      redirect_to custom_fields_path
    else
      render :new
    end
  end

  def edit
    if @custom_field
      @new_field_option = FieldOption.new if @custom_field.can_have_options?
    else
      redirect_to custom_fields_path
    end
  end

  def update
    if @custom_field
      if @custom_field.update_attributes(custom_field_params)
        redirect_to edit_custom_field_path(@custom_field)
      else
        render :edit
      end
    else
      redirect_to custom_fields_path
    end
  end

  private

  def custom_field
    @custom_field = current_user.custom_fields.find_by(id: params[:id])
  end

  def custom_field_params
    params.require(:custom_field).permit(:name, :entity_type_id, :field_type_id, :required)
  end

end
