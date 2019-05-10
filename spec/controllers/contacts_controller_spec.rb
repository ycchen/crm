require 'rails_helper'

RSpec.describe ContactsController, type: :controller do

  describe 'GET index' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:user3) { create(:user) }
    let!(:contact) { create(:contact, user: user, tags_string: 'apple banana', last_contacted: 3.days.ago) }
    let!(:contact2) { create(:contact, user: user, tags_string: 'orange red', last_contacted: 2.days.ago) }
    let!(:contact3) { create(:contact, user: user2, tags_string: 'blue yellow') }

    it 'redirects anon' do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns success' do
      sign_in user
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:contacts)).to eq([contact, contact2])
    end

    it 'no contacts redirects' do
      sign_in user3
      get :index
      expect(response).to redirect_to(new_contact_path)
      expect(assigns(:contacts)).to eq([])
    end

    it 'known query returns contacts' do
      sign_in user
      get :index, params: { query: contact.first_name }
      expect(response).to have_http_status(:success)
      expect(assigns(:query)).to eq(contact.first_name.downcase)
      expect(assigns(:contacts)).to eq([contact])
    end

    it 'known complex query returns contacts' do
      sign_in user
      get :index, params: { query: 'first last' }
      expect(response).to have_http_status(:success)
      expect(assigns(:query)).to eq('first last')
      expect(assigns(:contacts)).to eq([contact, contact2])
    end

    it 'known query returns contacts based on tag' do
      sign_in user
      get :index, params: { query: 'apple' }
      expect(response).to have_http_status(:success)
      expect(assigns(:query)).to eq('apple')
      expect(assigns(:contacts)).to eq([contact])
    end

    it 'known complex query returns contacts based on tag' do
      sign_in user
      get :index, params: { query: 'apple banana' }
      expect(response).to have_http_status(:success)
      expect(assigns(:query)).to eq('apple banana')
      expect(assigns(:contacts)).to eq([contact])
    end

    it 'unknown query returns no contacts' do
      sign_in user
      get :index, params: { query: 'foo' }
      expect(response).to have_http_status(:success)
      expect(assigns(:query)).to eq('foo')
      expect(assigns(:contacts)).to eq([])
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
      expect(assigns(:contact).class).to eq(Contact)
    end
  end

  describe 'POST create' do
    let(:user) { create(:user) }
    let(:entity_type) { create(:entity_type, :contact) }
    let!(:custom_field) { create(:custom_field, :text, entity_type: entity_type, user: user, required: true) }
    let(:params) { { contact: { first_name: 'foo', last_name: 'bar' }, custom_fields: { custom_field.id => 'foo' } } }
    let(:params2) { { contact: { first_name: 'foo', last_name: 'bar' } } }

    it 'redirects anon' do
      post :create, params: {}
      expect(response).to have_http_status(:redirect)
    end

    it 'returns a valid response' do
      sign_in user
      expect {
        expect {
          post :create, params: params
        }.to change { FieldValue.count }.by(1)
      }.to change { Contact.count }.by(1)
      expect(response).to redirect_to(new_contact_followup_path(assigns(:contact)))
    end

    it 'returns an invalid response with no custom field params' do
      sign_in user
      expect {
        expect {
          post :create, params: params2
        }.to change { FieldValue.count }.by(0)
      }.to change { Contact.count }.by(1)
      expect(response).to redirect_to(edit_contact_path(assigns(:contact)))
    end

    it 'returns an invalid response' do
      sign_in user
      expect {
        params[:contact][:first_name] = nil
        post :create, params: params
      }.to change { Contact.count }.by(0)
      expect(response).to render_template(:new)
    end

    it 'invalid custom field value returns an invalid response' do
      sign_in user
      expect {
        expect {
          params[:custom_fields] = { custom_field.id => '' }
          post :create, params: params
        }.to change { FieldValue.count }.by(0)
      }.to change { Contact.count }.by(1)
      expect(response).to redirect_to(edit_contact_path(assigns(:contact)))
    end
  end

  describe 'GET edit' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let!(:contact) { create(:contact, user: user) }

    it 'redirects anon' do
      get :edit, params: { id: contact.id }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns success' do
      sign_in user
      get :edit, params: { id: contact.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:contact)).to eq(contact)
    end

    it 'no contact redirects' do
      sign_in user2
      get :edit, params: { id: contact.id }
      expect(response).to redirect_to(contacts_path)
      expect(assigns(:contact)).to eq(nil)
    end
  end

  describe 'POST update' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:entity_type) { create(:entity_type, :contact) }
    let(:contact) { create(:contact, user: user) }
    let(:custom_field) { create(:custom_field, :text, entity_type: entity_type, user: user, required: true) }
    let!(:field_value) { create(:field_value, custom_field: custom_field, entity: contact, value: 'foo') }

    it 'redirects anon' do
      get :update, params: { id: 0 }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects wrong owner' do
      sign_in user2
      get :update, params: { id: contact.id }
      expect(response).to redirect_to(contacts_path)
    end

    it 'returns success' do
      sign_in user
      get :update, params: { id: contact.id, contact: { first_name: 'other' }, custom_fields: { custom_field.id => 'bar' } }
      expect(response).to redirect_to(edit_contact_path(contact))
      expect(assigns(:contact)).to eq(contact)
      expect(assigns(:contact).first_name).to eq('other')
      expect(field_value.reload.value).to eq('bar')
    end

    it 'invalid contact value renders edit' do
      sign_in user
      get :update, params: { id: contact.id, contact: { first_name: '' }, custom_fields: { custom_field.id => 'bar' } }
      expect(response).to have_http_status(:success)
      expect(assigns(:contact)).to eq(contact)
      expect(assigns(:contact).first_name).to eq('')
      expect(assigns(:contact).errors[:first_name]).to be_present
      expect(assigns(:errors)["_#{custom_field.id}".to_sym]).to_not be_present
      expect(field_value.reload.value).to eq('bar')
    end

    it 'invalid custom field value renders edit' do
      sign_in user
      get :update, params: { id: contact.id, contact: { first_name: 'other' }, custom_fields: { custom_field.id => '' } }
      expect(response).to have_http_status(:success)
      expect(assigns(:contact)).to eq(contact)
      expect(assigns(:contact).first_name).to eq('other')
      expect(assigns(:contact).errors[:first_name]).to_not be_present
      expect(assigns(:errors)["_#{custom_field.id}".to_sym]).to be_present
      expect(field_value.reload.value).to eq('foo')
    end
  end

  describe 'GET autocomplete' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let!(:contact) { create(:contact, user: user) }
    let!(:contact2) { create(:contact, user: user) }
    let(:suggestions) { JSON.parse(response.body)['suggestions'] }

    it 'redirects anon' do
      get :autocomplete
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns valid response for partial first name' do
      sign_in user
      get :autocomplete, params: { query: contact.first_name[0..3] }
      expect(response).to have_http_status(:success)
      expected = [{ 'value' => contact.fullname, 'data' => contact.id }, { 'value' => contact2.fullname, 'data' => contact2.id }]
      expect(suggestions).to eq(expected)
    end

    it 'returns valid response for first name' do
      sign_in user
      get :autocomplete, params: { query: contact.first_name }
      expect(response).to have_http_status(:success)
      expected = [{ 'value' => contact.fullname, 'data' => contact.id }]
      expect(suggestions).to eq(expected)
    end

    it 'returns valid response for full name' do
      sign_in user
      get :autocomplete, params: { query: contact.fullname }
      expect(response).to have_http_status(:success)
      expected = [{ 'value' => contact.fullname, 'data' => contact.id }]
      expect(suggestions).to eq(expected)
    end

    it 'wrong user returns no results' do
      sign_in user2
      get :autocomplete, params: { query: contact.first_name }
      expect(response).to have_http_status(:success)
      expect(suggestions).to eq([])
    end
  end
end
