require 'rails_helper'

RSpec.describe SaleItem, type: :model do

  describe 'validation' do
    let(:sale_item) { build(:sale_item) }

    it 'has a valid factory' do
      expect(sale_item.valid?).to be_truthy
    end

    it 'requires a product' do
      sale_item.product = nil
      expect(sale_item.valid?).to be_falsey
    end

    it 'requires a sale' do
      sale_item.sale = nil
      expect(sale_item.valid?).to be_falsey
    end

    it 'has a minimum quantity' do
      sale_item.quantity = 0
      expect(sale_item.valid?).to be_falsey
    end

    it 'has a maximum quantity' do
      sale_item.quantity = 1001
      expect(sale_item.valid?).to be_falsey
    end

    it 'has a minimum price' do
      sale_item.price = -1
      expect(sale_item.valid?).to be_falsey
    end

    it 'has a maximum price' do
      sale_item.price = 10_000_001
      expect(sale_item.valid?).to be_falsey
    end
  end

  describe 'belongs to a product' do
    let(:product) { create(:product) }
    let(:sale_item) { build(:sale_item, product: product) }

    it 'returns a product' do
      expect(sale_item.product).to eq(product)
    end
  end

  describe 'belongs to a sale' do
    let(:sale) { create(:sale) }
    let(:sale_item) { build(:sale_item, sale: sale) }

    it 'returns a sale' do
      expect(sale_item.sale).to eq(sale)
    end
  end

  describe 'scope' do
    let!(:sale_item1) { create(:sale_item) }
    let!(:sale_item2) { create(:sale_item) }

    describe '.ordered' do
      it 'returns sale items ordered by id' do
        expect(SaleItem.ordered).to eq([sale_item1, sale_item2])
      end
    end
  end

end
