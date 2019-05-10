class FieldOptionsController < ApplicationController

  before_action :authenticate_user!
  before_action :custom_field, only: [:create, :destroy, :save_sort]

  def create
    @field_option = @custom_field.field_options.create(field_option_params)
    @new_field_option = FieldOption.new
  end

  def destroy
    @field_option = @custom_field.field_options.find_by(id: params[:id])
    if @field_option
      @id = @field_option.id
      @field_option.destroy
    end
    @new_field_option = FieldOption.new
  end

  def save_sort
    save_sorted(@custom_field.field_options)
    head :ok
  end

  private

  def custom_field
    @custom_field = current_user.custom_fields.find_by(id: params[:custom_field_id])
    head :unauthorized unless @custom_field
  end

  def field_option_params
    params.require(:field_option).permit(:name)
  end

end
