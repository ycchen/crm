class FieldValue < ApplicationRecord
  include PolymorphicIntegerType::Extensions

  belongs_to :custom_field
  belongs_to :entity, polymorphic: true, integer_type: true

  validates :custom_field, presence: true
  validates :entity, presence: true
  validates :value, length: { maximum: 1024 }

  class << self

    def value_for(entity, custom_field)
      field_value = entity.field_values.find_by(custom_field: custom_field)
      return field_value.value if field_value
      ''
    end

    def save_value(entity, custom_field, value)
      field_value = entity.field_values.find_by(custom_field: custom_field)
      if field_value
        field_value.update_attributes(value: value)
      else
        field_value = entity.field_values.create(custom_field: custom_field, value: value)
      end
      field_value
    end

    def value_select(field, value, errors)
      option = field.field_options.find_by(id: value)
      errors["_#{field.id}".to_sym] = 'required field' if field.required && option.nil?
      value = option.id if option
      [value, errors]
    end

    alias value_radio value_select

    def value_checkboxes(field, value, errors)
      values = []
      value.each do |id, val|
        next if val.to_i.zero?
        option = field.field_options.find_by(id: id)
        next unless option
        values << option.id
      end
      errors["_#{field.id}".to_sym] = 'required field' if field.required && values.empty?
      [values.join(','), errors]
    end

    def value_url(field, value, errors)
      errors["_#{field.id}".to_sym] = 'invalid url' if field.required && value !~ URI.regexp
      [value, errors]
    end

    def value_email(field, value, errors)
      errors["_#{field.id}".to_sym] = 'invalid email' if field.required && value !~ Devise.email_regexp
      [value, errors]
    end

    def value_date(field, value, errors)
      if field.required && value.blank?
        errors["_#{field.id}".to_sym] = 'required field'
      elsif field.required
        begin
          Date.parse(value)
        rescue ArgumentError
          errors["_#{field.id}".to_sym] = 'invalid date'
        end
      end
      [value, errors]
    end

    def value_datetime(field, value, errors)
      if field.required && value.blank?
        errors["_#{field.id}".to_sym] = 'required field'
      elsif field.required
        begin
          DateTime.parse(value)
        rescue ArgumentError
          errors["_#{field.id}".to_sym] = 'invalid datetime'
        end
      end
      [value, errors]
    end

    def value_time(field, value, errors)
      if field.required && value.blank?
        errors["_#{field.id}".to_sym] = 'required field'
      elsif field.required
        begin
          Time.parse(value)
        rescue ArgumentError
          errors["_#{field.id}".to_sym] = 'invalid time'
        end
      end
      [value, errors]
    end

    def value_checkbox(_, value, errors)
      [value, errors]
    end

    def value_text(field, value, errors)
      errors["_#{field.id}".to_sym] = 'required field' if field.required && value.blank?
      [value, errors]
    end

    alias value_textarea value_text
    alias value_range    value_text
    alias value_color    value_text

    def value_number(_, value, errors)
      [value.to_i, errors]
    end

    def update_values(user, entity, params)
      errors = {}
      entity_type = EntityType.find_by(name: entity.class.to_s)
      raise 'EntityType not found' unless entity_type
      user.custom_fields.where(entity_type: entity_type).each do |field|
        id = field.id.to_s
        value = params.include?(id) ? params[id] : nil
        value, errors = send("value_#{field.field_type.name}".to_sym, field, value, errors)
        k = "_#{id}".to_sym
        if !errors[k].blank? && field.required && value.blank?
          errors[k] = 'required field'
          next
        end
        field_value = FieldValue.save_value(entity, field, value)
        next if field_value.valid?
        errors[k] = field_value.errors[:value].first if field_value.errors && field_value.errors[:value]
      end
      errors
    end
  end

end
