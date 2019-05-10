require 'rails_helper'

RSpec.describe PhonesController, type: :controller do

  describe 'GET new' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:contact) { create(:contact, user: user) }

    it 'redirects anon' do
      get :new, params: { contact_id: 0 }
      expect(response).to have_http_status(:redirect)
    end

    it 'xhr returns unauthorized for anon' do
      get :new, xhr: true, params: { contact_id: 0 }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns a valid response' do
      sign_in user
      get :new, xhr: true, params: { contact_id: contact.id }
      expect(assigns(:contact)).to eq(contact)
      expect(assigns(:phone).class).to eq(Phone)
      expect(response).to render_template(:new)
    end

    it 'returns unauthorized for unowned contact' do
      sign_in user2
      get :new, xhr: true, params: { contact_id: contact.id }
      expect(assigns(:contact)).to eq(nil)
      expect(assigns(:phone)).to eq(nil)
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET cancel_new' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let!(:contact) { create(:contact, user: user) }

    it 'redirects anon' do
      get :cancel_new, params: { contact_id: 0 }
      expect(response).to have_http_status(:redirect)
    end

    it 'xhr returns unauthorized for anon' do
      get :cancel_new, xhr: true, params: { contact_id: 0 }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns a valid response' do
      sign_in user
      get :cancel_new, xhr: true, params: { contact_id: contact.id }
      expect(assigns(:contact)).to eq(contact)
      expect(response).to render_template(:cancel_new)
    end

    it 'returns unauthorized for unowned contact' do
      sign_in user2
      get :cancel_new, xhr: true, params: { contact_id: contact.id }
      expect(assigns(:contact)).to eq(nil)
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST create' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:contact) { create(:contact, user: user) }
    let(:phone_type) { create(:phone_type) }
    let(:params) { { contact_id: contact.id, phone: { phone_type_id: phone_type.id, number: '12312312345' } } }

    it 'redirects anon' do
      post :create, params: { contact_id: 0 }
      expect(response).to have_http_status(:redirect)
    end

    it 'xhr returns unauthorized for anon' do
      post :create, xhr: true, params: { contact_id: 0 }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns a valid response' do
      sign_in user
      expect {
        post :create, xhr: true, params: params
      }.to change { Phone.count }.by(1)
      expect(response).to render_template(:create)
    end

    it 'returns unauthorized for unowned contact' do
      sign_in user2
      expect {
        post :create, xhr: true, params: params
        expect(assigns(:contact)).to eq(nil)
        expect(response).to have_http_status(:unauthorized)
      }.to change { Phone.count }.by(0)
    end
  end

  describe 'GET edit' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:contact) { create(:contact, user: user) }
    let(:phone) { create(:phone, contact: contact) }
    let(:params) { { contact_id: contact.id, id: phone.id } }

    it 'redirects anon' do
      get :edit, params: { contact_id: 0, id: 0 }
      expect(response).to have_http_status(:redirect)
    end

    it 'xhr returns unauthorized for anon' do
      get :edit, xhr: true, params: { contact_id: 0, id: 0 }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns a valid response' do
      sign_in user
      get :edit, xhr: true, params: params
      expect(assigns(:contact)).to eq(contact)
      expect(assigns(:phone)).to eq(phone)
      expect(response).to render_template(:edit)
    end

    it 'returns unauthorized for unowned contact' do
      sign_in user2
      get :edit, xhr: true, params: params
      expect(assigns(:contact)).to eq(nil)
      expect(assigns(:phone)).to eq(nil)
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET cancel_edit' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:contact) { create(:contact, user: user) }
    let(:phone) { create(:phone, contact: contact) }
    let(:params) { { contact_id: contact.id, id: phone.id } }

    it 'redirects anon' do
      get :cancel_edit, params: { contact_id: 0, id: 0 }
      expect(response).to have_http_status(:redirect)
    end

    it 'xhr returns unauthorized for anon' do
      get :cancel_edit, xhr: true, params: { contact_id: 0, id: 0 }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns a valid response' do
      sign_in user
      get :cancel_edit, xhr: true, params: params
      expect(assigns(:contact)).to eq(contact)
      expect(assigns(:phone)).to eq(phone)
      expect(response).to render_template(:cancel_edit)
    end

    it 'returns unauthorized for unowned contact' do
      sign_in user2
      get :cancel_edit, xhr: true, params: params
      expect(assigns(:contact)).to eq(nil)
      expect(assigns(:phone)).to eq(nil)
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST update' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:contact) { create(:contact, user: user) }
    let(:phone) { create(:phone, contact: contact) }
    let(:contact2) { create(:contact, user: user2) }
    let(:phone2) { create(:phone, contact: contact2) }
    let(:phone_type) { create(:phone_type, :other) }
    let(:number) { '3213213210' }
    let(:params) { { contact_id: contact.id, id: phone.id, phone: { phone_type_id: phone_type.id, number: number } } }

    it 'redirects anon' do
      post :update, params: { contact_id: 0, id: 0 }
      expect(response).to have_http_status(:redirect)
    end

    it 'xhr returns unauthorized for anon' do
      post :update, xhr: true, params: { contact_id: 0, id: 0 }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns a valid response' do
      sign_in user
      post :update, xhr: true, params: params
      expect(response).to render_template(:update)
      expect(assigns(:phone).phone_type.name).to eq(phone_type.name)
      expect(assigns(:phone).number).to eq(number)
    end

    it 'returns unauthorized for unowned contact' do
      sign_in user2
      post :update, xhr: true, params: params
      expect(assigns(:contact)).to eq(nil)
      expect(assigns(:phone)).to eq(nil)
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized for unowned phone' do
      sign_in user2
      post :update, xhr: true, params: { contact_id: contact2.id, id: phone.id, phone: { phone_type_id: phone_type.id, number: number } }
      expect(assigns(:contact)).to eq(contact2)
      expect(assigns(:phone)).to eq(nil)
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
