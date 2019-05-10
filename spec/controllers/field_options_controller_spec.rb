require 'rails_helper'

RSpec.describe FieldOptionsController, type: :controller do

  describe 'POST create' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:custom_field) { create(:custom_field, user: user) }
    let(:params) { { custom_field_id: custom_field.id, field_option: { name: 'foo' } } }

    it 'redirects anon' do
      post :create, params: { custom_field_id: 0 }
      expect(response).to have_http_status(:redirect)
    end

    it 'xhr returns unauthorized for anon' do
      post :create, xhr: true, params: { custom_field_id: 0 }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns a valid response' do
      sign_in user
      expect {
        post :create, xhr: true, params: params
      }.to change { FieldOption.count }.by(1)
      expect(response).to render_template(:create)
    end

    it 'returns unauthorized for unowned custom field' do
      sign_in user2
      expect {
        post :create, xhr: true, params: params
        expect(response).to have_http_status(:unauthorized)
        expect(assigns(:field_option)).to eq(nil)
      }.to change { FieldOption.count }.by(0)
    end
  end

  describe 'POST destroy' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:custom_field) { create(:custom_field, user: user) }
    let(:field_option) { create(:field_option, custom_field: custom_field) }
    let!(:params) { { custom_field_id: custom_field.id, id: field_option.id } }

    it 'redirects anon' do
      post :destroy, params: params
      expect(response).to have_http_status(:redirect)
    end

    it 'xhr returns unauthorized for anon' do
      post :destroy, xhr: true, params: params
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns a valid response' do
      sign_in user
      expect {
        post :destroy, xhr: true, params: params
      }.to change { FieldOption.count }.by(-1)
      expect(response).to render_template(:destroy)
    end

    it 'returns unauthorized for unowned custom field' do
      sign_in user2
      expect {
        post :destroy, xhr: true, params: params
        expect(response).to have_http_status(:unauthorized)
        expect(assigns(:custom_field)).to eq(nil)
        expect(assigns(:field_option)).to eq(nil)
      }.to change { FieldOption.count }.by(0)
    end
  end

  describe 'POST save_sort' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:option1) { create(:field_option) }
    let(:option2) { create(:field_option) }
    let(:custom_field) { create(:custom_field, user: user, field_options: [option1, option2]) }
    let!(:params) { { custom_field_id: custom_field.id, order: "option[]=#{option2.id}&option[]=#{option1.id}" } }

    it 'redirects anon' do
      post :save_sort, params: params
      expect(response).to have_http_status(:redirect)
    end

    it 'xhr returns unauthorized for anon' do
      post :save_sort, xhr: true, params: params
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns a valid response' do
      sign_in user
      post :save_sort, xhr: true, params: params
      expect(response).to have_http_status(:success)
      expect(assigns(:custom_field).field_options.ordered).to eq([option2, option1])
    end

    it 'returns unauthorized for unowned custom field' do
      sign_in user2
      post :save_sort, xhr: true, params: params
      expect(response).to have_http_status(:unauthorized)
      expect(assigns(:custom_field)).to eq(nil)
    end
  end

end
