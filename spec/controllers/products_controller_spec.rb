require 'rails_helper'

RSpec.describe ProductsController, type: :controller do

  describe 'GET index' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:product) { create(:product, user: user) }
    let(:product2) { create(:product, user: user2) }

    it 'redirects anon' do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns success' do
      sign_in user
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:products)).to eq([product])
    end

    it 'with a contact returns success' do
      sign_in user
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:products)).to eq([product])
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
      expect(assigns(:product).class).to eq(Product)
    end
  end

  describe 'POST create' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:img) { fixture_file_upload("#{Rails.root}/spec/factories/images/product.png", 'image/png') }
    let(:entity_type) { create(:entity_type, :product) }
    let(:custom_field) { create(:custom_field, :text, entity_type: entity_type, user: user, required: true) }
    let(:params) { { product: { name: 'foo', desc: 'bar', price: 1, img: img }, custom_fields: { custom_field.id => 'foo' } } }
    let(:params2) { { product: { name: 'foo', desc: 'bar', price: 1, img: img }, custom_fields: { custom_field.id => '' } } }

    it 'redirects anon' do
      post :create
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns a valid response' do
      sign_in user
      expect {
        post :create, params: params
      }.to change { Product.count }.by(1)
      expect(response).to redirect_to(products_path)
    end

    it 'invalid params renders :new' do
      sign_in user
      expect {
        post :create, params: { product: { name: '' } }
      }.to change { Product.count }.by(0)
      expect(response).to render_template(:new)
    end

    it 'invalid custom field params redirects to :edit' do
      sign_in user
      expect {
        post :create, params: params2
      }.to change { Product.count }.by(1)
      expect(response).to redirect_to(edit_product_path(assigns(:product)))
    end
  end

  describe 'GET edit' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:product) { create(:product, user: user) }

    it 'redirects anon' do
      get :edit, params: { id: 0 }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns a valid response' do
      sign_in user
      get :edit, params: { id: product.id }
      expect(assigns(:product)).to eq(product)
      expect(response).to render_template(:edit)
    end

    it 'returns unauthorized for unowned product' do
      sign_in user2
      get :edit, params: { id: product.id }
      expect(assigns(:product)).to eq(nil)
      expect(response).to redirect_to(products_path)
    end
  end

  describe 'POST update' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let!(:entity_type) { create(:entity_type, :product) }
    let(:product) { create(:product, user: user) }
    let(:custom_field) { create(:custom_field, :text, entity_type: entity_type, user: user, required: true) }
    let(:params) { { id: product.id, product: { name: 'Updated name' }, custom_fields: { custom_field.id => 'foo' } } }
    let(:params2) { { id: product.id, product: { name: '' } } }
    let(:params3) { { id: product.id, product: { name: 'Updated name' }, custom_fields: { custom_field.id => '' } } }

    it 'redirects anon' do
      post :update, params: { id: 0 }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns a valid response' do
      sign_in user
      post :update, params: params
      expect(assigns(:product)).to eq(product)
      expect(response).to redirect_to(edit_product_path(product))
    end

    it 'redirect for unowned product' do
      sign_in user2
      post :update, params: params
      expect(assigns(:product)).to eq(nil)
      expect(response).to redirect_to(products_path)
    end

    it 'return invalid for invalid value' do
      sign_in user
      post :update, params: params2
      expect(response).to render_template(:edit)
    end

    it 'return invalid for invalid custom field value' do
      sign_in user
      post :update, params: params3
      expect(response).to render_template(:edit)
    end
  end

  describe 'GET autocomplete' do
    let(:user) { create(:user) }
    let(:product) { create(:product, name: 'foo', user: user) }
    let(:product2) { create(:product, name: 'bar', user: user) }

    it 'redirects anon' do
      get :autocomplete, xhr: true, params: { query: '' }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns success' do
      product.save! && product2.save!
      sign_in user
      get :autocomplete, xhr: true, params: { query: 'f' }
      expect(response).to have_http_status(:success)
      expected = [{value: 'foo', data: product.id, price: product.price.to_s}]
      expect(assigns(:products)).to eq(expected)
    end
  end
end
