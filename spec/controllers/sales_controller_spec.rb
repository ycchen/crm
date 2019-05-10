require 'rails_helper'

RSpec.describe SalesController, type: :controller do

  describe 'GET index' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:sale) { create(:sale, user: user) }
    let(:sale2) { create(:sale, user: user2) }
    let!(:contact) { create(:contact, user: user, sales: [sale]) }
    let!(:contact2) { create(:contact, user: user2, sales: [sale2]) }

    it 'redirects anon' do
      get :index
      expect(response).to redirect_to(new_user_session_path)
      get :index, params: { contact_id: 0 }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns success' do
      sign_in user
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:sales)).to eq([sale])
    end

    it 'with a contact returns success' do
      sign_in user
      get :index, params: { contact_id: contact.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:contact)).to eq(contact)
      expect(assigns(:sales)).to eq([sale])
    end
  end

  describe 'GET new' do
    let(:user) { create(:user) }

    it 'redirects anon' do
      get :new
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns success' do
      sign_in user
      get :new
      expect(response).to have_http_status(:success)
      expect(assigns(:sale).class).to eq(Sale)
    end
  end

  describe 'POST create' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:contact) { create(:contact, user: user) }
    let(:params) { { sale: { contact_id: contact.id } } }

    it 'redirects anon' do
      post :create, params: { contact_id: 0 }
      expect(response).to have_http_status(:redirect)
    end

    it 'returns a valid response' do
      sign_in user
      expect {
        post :create, params: params
      }.to change { Sale.count }.by(1)
      expect(response).to redirect_to(sale_sale_items_path(assigns(:sale)))
    end

    it 'returns unauthorized for unowned contact' do
      sign_in user2
      expect {
        post :create, params: params
        expect(assigns(:contact)).to eq(nil)
        expect(response).to render_template(:new)
      }.to change { Sale.count }.by(0)
    end
  end

  describe 'POST update' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:sale) { create(:sale, user: user) }
    let(:entity_type) { create(:entity_type, :sale) }
    let(:custom_field) { create(:custom_field, :text, entity_type: entity_type, user: user, required: true) }
    let(:params) { { id: sale.id, custom_fields: { custom_field.id => 'foo' } } }
    let(:params2) { { id: sale.id, custom_fields: { custom_field.id => '' } } }

    it 'redirects anon' do
      post :update, params: { id: 0 }
      expect(response).to have_http_status(:redirect)
    end

    it 'returns a valid response' do
      sign_in user
      expect {
        post :update, params: params
      }.to change { FieldValue.count }.by(1)
      expect(response).to redirect_to(sale_sale_items_path(sale))
    end

    it 'returns an invalid response' do
      sign_in user
      expect {
        post :update, params: params2
      }.to change { FieldValue.count }.by(0)
      expect(response).to render_template('sale_items/index')
      expect(assigns(:sale).class).to eq(Sale)
    end
  end

end
