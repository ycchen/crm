require 'rails_helper'

RSpec.describe CustomFieldsController, type: :controller do

  describe 'GET index' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let!(:custom_field) { create(:custom_field, user: user) }

    it 'redirects anon' do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns success' do
      sign_in user
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:custom_fields)).to eq([custom_field])
    end

    it 'returns no custom fields' do
      sign_in user2
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:custom_fields)).to eq([])
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
      expect(assigns(:custom_field).class).to eq(CustomField)
    end
  end

  describe 'POST create' do
    let(:user) { create(:user) }
    let(:entity_type) { create(:entity_type) }
    let(:field_type) { create(:field_type) }
    let(:params) { { custom_field: { name: 'foo', entity_type_id: entity_type.id, field_type_id: field_type.id } } }

    it 'redirects anon' do
      post :create, params: {}
      expect(response).to have_http_status(:redirect)
    end

    it 'returns a valid response' do
      sign_in user
      expect {
        post :create, params: params
      }.to change { CustomField.count }.by(1)
      expect(response).to redirect_to(custom_fields_path)
    end

    it 'returns an invalid response' do
      sign_in user
      expect {
        params[:custom_field][:field_type_id] = 0
        post :create, params: params
      }.to change { CustomField.count }.by(0)
      expect(response).to render_template(:new)
    end
  end

  describe 'GET edit' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:custom_field) { create(:custom_field, user: user) }
    let(:params) { { id: custom_field.id, custom_field: { name: 'foo' } } }

    it 'redirects anon' do
      get :edit, params: { id: 0 }
      expect(response).to have_http_status(:redirect)
    end

    it 'returns a valid response' do
      sign_in user
      get :edit, params: params
      expect(assigns(:custom_field)).to eq(custom_field)
      expect(response).to render_template(:edit)
    end

    it 'returns unauthorized for unowned contact' do
      sign_in user2
      get :edit, params: params
      expect(assigns(:custom_field)).to eq(nil)
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'POST update' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:custom_field) { create(:custom_field, user: user) }
    let(:params) { { id: custom_field.id, custom_field: { name: 'foo' } } }
    let(:params2) { { id: custom_field.id, custom_field: { name: '' } } }

    it 'redirects anon' do
      post :update, params: { id: 0 }
      expect(response).to have_http_status(:redirect)
    end

    it 'returns a valid response' do
      sign_in user
      post :update, params: params
      expect(response).to redirect_to(edit_custom_field_path(custom_field))
    end

    it 'returns a valid response for wrong user' do
      sign_in user2
      post :update, params: params
      expect(response).to redirect_to(custom_fields_path)
    end

    it 'returns an invalid response' do
      sign_in user
      post :update, params: params2
      expect(response).to render_template(:edit)
      expect(response).to have_http_status(:success)
    end
  end
end
