require 'rails_helper'

RSpec.describe Product, type: :model do

  describe 'validation' do
    let(:product) { build(:product) }

    it 'has a valid factory' do
      expect(product.valid?).to be_truthy
    end

    it 'requires a user' do
      product.user = nil
      expect(product.valid?).to be_falsey
    end

    it 'requires a name' do
      product.name = nil
      expect(product.valid?).to be_falsey
    end

    it 'requires a description' do
      product.desc = nil
      expect(product.valid?).to be_falsey
    end

    it 'requires a price' do
      product.price = nil
      expect(product.valid?).to be_falsey
    end

    it 'has a minimum price' do
      product.price = -1
      expect(product.valid?).to be_falsey
    end

    it 'has a maximum price' do
      product.price = 10_000_001
      expect(product.valid?).to be_falsey
    end

    it 'attachment must be an image' do
      product.img = File.new("#{Rails.root}/spec/factories/images/not_an_image.txt")
      product.save
      expect(product.valid?).to be_falsey
    end
  end

  describe 'has_attached_file' do
    let(:product) { create(:product) }

    it 'returns image field name' do
      expect(product.img.name).to eq(:img)
    end

    it 'returns an image content type' do
      expect(product.img.instance.img_content_type).to eq('image/png')
    end
  end

  describe 'has many field values' do
    let(:custom_field1) { create(:custom_field) }
    let(:custom_field2) { create(:custom_field) }
    let(:field_value1) { create(:field_value, custom_field: custom_field1) }
    let(:field_value2) { create(:field_value, custom_field: custom_field2) }
    let!(:product) { create(:product, field_values: [field_value1, field_value2]) }

    it 'returns field values' do
      expect(product.field_values.size).to eq(2)
      expect(product.field_values.include?(field_value1)).to be_truthy
      expect(product.field_values.include?(field_value2)).to be_truthy
    end

    it 'destroys dependent field values' do
      expect { product.destroy }.to change { FieldValue.count }.by(-2)
    end
  end

  describe 'belongs to a user' do
    let(:user) { create(:user) }
    let!(:product) { create(:product, user: user) }

    it 'has a user' do
      expect(product.user).to eq(user)
    end
  end

  describe 'scopes' do
    describe '.ordered' do
      let!(:product1) { create(:product, name: 'a') }
      let!(:product2) { create(:product, name: 'b') }

      it 'returns products ordered by name' do
        expected = [product1, product2]
        expect(Product.ordered).to eq(expected)
      end
    end
  end
end
