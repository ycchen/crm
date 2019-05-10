require 'rails_helper'

RSpec.describe EntityType, type: :model do
  
  describe 'validation' do
    let(:entity_type) { build(:entity_type) }

    it 'has a valid factory' do
      expect(entity_type.valid?).to be_truthy
    end

    it 'requires a name' do
      entity_type.name = nil
      expect(entity_type.valid?).to be_falsey
    end

    it 'name must be less than 33 chars' do
      entity_type.name = 'x' * 33
      expect(entity_type.valid?).to be_falsey
    end
  end

  describe 'singleton methods' do
    let!(:contact) { create(:entity_type, :contact) }
    let!(:followup) { create(:entity_type, :followup) }
    let!(:product) { create(:entity_type, :product) }
    let!(:sale) { create(:entity_type, :sale) }

    it 'returns contact type' do
      expect(EntityType.contact).to eq(contact)
    end

    it 'returns followup type' do
      expect(EntityType.followup).to eq(followup)
    end

    it 'returns product type' do
      expect(EntityType.product).to eq(product)
    end

    it 'returns sale type' do
      expect(EntityType.sale).to eq(sale)
    end
  end
end
