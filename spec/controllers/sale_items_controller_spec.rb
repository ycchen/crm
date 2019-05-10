require 'rails_helper'

RSpec.describe SaleItemsController, type: :controller do

  describe 'GET index' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:sale) { create(:sale, user: user) }
    let(:sale2) { create(:sale, user: user2) }
    let(:sale_item) { create(:sale_item) }
    let(:entity_type) { create(:entity_type, :sale) }
    let(:custom_field) { create(:custom_field, entity_type: entity_type) }

    it 'redirects anon' do
      get :index, params: { sale_id: sale.id }
      expect(response).to redirect_to(new_user_session_path)
      get :index, params: { sale_id: 0 }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns success' do
      sign_in user
      get :index, params: { sale_id: sale.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:sale)).to eq(sale)
      expect(assigns(:sale_item).class).to eq(SaleItem)
    end

    it 'returns failure for unowned sale' do
      sign_in user2
      get :index, params: { sale_id: sale.id }
      expect(response).to have_http_status(:redirect)
      expect(assigns(:sale)).to eq(nil)
    end

    it 'with a sale returns success' do
      sign_in user
      sale.sale_items << sale_item
      user.custom_fields << custom_field
      get :index, params: { sale_id: sale.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:sale)).to eq(sale)
      expect(assigns(:sale_items)).to eq([sale_item])
      expect(assigns(:custom_fields)).to eq([custom_field])
    end
  end

  describe 'POST create' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:sale) { create(:sale, user: user) }
    let(:product) { create(:product) }
    let(:params) { { sale_id: sale.id, sale_item: { product_id: product.id, quantity: 1, price: product.price } } }

    it 'redirects anon' do
      post :create, params: { sale_id: 0 }
      expect(response).to have_http_status(:redirect)
    end

    it 'returns an invalid response for wrong user' do
      sign_in user2
      expect {
        post :create, params: params
      }.to change { SaleItem.count }.by(0)
      expect(response).to have_http_status(:redirect)
    end

    it 'returns a valid response' do
      sign_in user
      expect {
        post :create, params: params
      }.to change { SaleItem.count }.by(1)
      expect(response).to redirect_to(sale_sale_items_path(assigns(:sale)))
    end
  end

  describe 'POST destroy' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:sale) { create(:sale, user: user) }
    let!(:sale_item) { create(:sale_item, sale: sale) }

    it 'redirects anon' do
      post :destroy, params: { sale_id: sale.id, id: sale_item.id }
      expect(response).to have_http_status(:redirect)
    end

    it 'returns an invalid response for wrong user' do
      sign_in user2
      expect {
        post :destroy, params: { sale_id: sale.id, id: sale_item.id }
      }.to change { SaleItem.count }.by(0)
      expect(response).to have_http_status(:redirect)
    end

    it 'returns a valid response' do
      sign_in user
      expect {
        post :destroy, params: { sale_id: sale.id, id: sale_item.id }
      }.to change { SaleItem.count }.by(-1)
      expect(response).to redirect_to(sale_sale_items_path(assigns(:sale)))
    end
  end
end
