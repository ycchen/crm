module CustomFieldsHelper

  def checkbox_checked(entity, field)
    FieldValue.value_for(entity, field) == '1'
  end

  def option_checkbox_checked(entity, field, option, params)
    option_ids =
      if params && params[:custom_fields] && params[:custom_fields][field.id.to_s]
        params[:custom_fields][field.id.to_s].collect { |k, _| k.to_s }
      else
        FieldValue.value_for(entity, field).split(',')
      end
    option_ids.include?(option.id.to_s)
  end

  def select_option_selected(entity, field, option, params)
    value =
      if params && params[:custom_fields] && params[:custom_fields][field.id.to_s]
        params[:custom_fields][field.id.to_s].to_s
      else
        FieldValue.value_for(entity, field)
      end
    option.id.to_s == value
  end

end
