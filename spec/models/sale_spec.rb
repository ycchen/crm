require 'rails_helper'

RSpec.describe Sale, type: :model do

  describe 'validation' do
    let(:sale) { build(:sale) }

    it 'has a valid factory' do
      expect(sale.valid?).to be_truthy
    end

    it 'requires a user' do
      sale.user = nil
      expect(sale.valid?).to be_falsey
    end

    it 'requires a contact' do
      sale.contact = nil
      expect(sale.valid?).to be_falsey
    end
  end

  describe 'belongs to a user' do
    let(:user) { create(:user) }
    let!(:sale) { create(:sale, user: user) }

    it 'has a user' do
      expect(sale.user).to eq(user)
    end
  end

  describe 'belongs to a contact' do
    let(:contact) { create(:contact) }
    let!(:sale) { create(:sale, contact: contact) }

    it 'has a contact' do
      expect(sale.contact).to eq(contact)
    end
  end

  describe 'scopes' do
    describe '.ordered' do
      let!(:sale1) { create(:sale) }
      let!(:sale2) { create(:sale) }

      it 'returns sales ordered by created_at desc' do
        expected = [sale2, sale1]
        expect(Sale.ordered).to eq(expected)
      end
    end
  end

  describe 'has many sale items' do
    let(:sale_item1) { create(:sale_item) }
    let(:sale_item2) { create(:sale_item) }
    let!(:sale) { create(:sale, sale_items: [sale_item1, sale_item2]) }

    it 'returns sale items' do
      expect(sale.sale_items.size).to eq(2)
      expect(sale.sale_items.include?(sale_item1)).to be_truthy
      expect(sale.sale_items.include?(sale_item2)).to be_truthy
    end

    it 'destroys dependent sale items' do
      expect { sale.destroy }.to change { SaleItem.count }.by(-2)
    end
  end

  describe 'has many field values' do
    let(:custom_field1) { create(:custom_field) }
    let(:custom_field2) { create(:custom_field) }
    let(:field_value1) { create(:field_value, custom_field: custom_field1) }
    let(:field_value2) { create(:field_value, custom_field: custom_field2) }
    let!(:sale) { create(:sale, field_values: [field_value1, field_value2]) }

    it 'returns field values' do
      expect(sale.field_values.size).to eq(2)
      expect(sale.field_values.include?(field_value1)).to be_truthy
      expect(sale.field_values.include?(field_value2)).to be_truthy
    end

    it 'destroys dependent field values' do
      expect { sale.destroy }.to change { FieldValue.count }.by(-2)
    end
  end

  describe '#total' do
    let(:sale_item1) { create(:sale_item) }
    let(:sale_item2) { create(:sale_item) }
    let!(:sale) { create(:sale, sale_items: [sale_item1, sale_item2]) }

    it 'returns sale items' do
      expect(sale.total).to eq(19.98)
    end
  end

  describe '#pretty_created_at' do
    let(:sale) { build(:sale, created_at: Time.parse('1972-08-10 12:00:00')) }

    it 'has a valid factory' do
      expect(sale.pretty_created_at).to eq('Aug 10, 1972')
    end
  end
end
