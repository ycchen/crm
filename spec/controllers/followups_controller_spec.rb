require 'rails_helper'

RSpec.describe FollowupsController, type: :controller do

  describe 'GET index' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:followup) { create(:followup, user: user) }
    let(:followup2) { create(:followup, user: user2) }
    let(:followup3) { create(:followup, :completed) }
    let!(:contact) { create(:contact, user: user, followups: [followup, followup3]) }
    let!(:contact2) { create(:contact, user: user2, followups: [followup2]) }

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
      expect(assigns(:followups)).to eq([followup])
    end

    it 'with a contact returns success' do
      sign_in user
      get :index, params: { contact_id: contact.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:contact)).to eq(contact)
      expect(assigns(:followups)).to eq([followup])
    end

    it 'returns completed followups' do
      sign_in user
      get :index, params: { contact_id: contact.id }, session: { show_completed_followups: 1 }
      expect(response).to have_http_status(:success)
      expect(assigns(:contact)).to eq(contact)
      expect(assigns(:followups)).to eq([followup3])
    end
  end

  describe 'GET completed' do
    let(:user) { create(:user) }
    let!(:contact) { create(:contact, user: user) }

    it 'redirects anon' do
      get :completed
      expect(response).to redirect_to(new_user_session_path)
      get :completed, params: { contact_id: 0 }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'sets session variable and redirects' do
      sign_in user
      get :completed
      expect(response).to redirect_to(followups_path)
      get :completed, params: { contact_id: contact.id }
      expect(response).to redirect_to(contact_followups_path)
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
      expect(assigns(:followup).class).to eq(Followup)
    end
  end

  describe 'POST create' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:contact) { create(:contact, user: user) }
    let(:followup_type) { create(:followup_type) }
    let(:now) { Time.current }
    let!(:entity_type) { create(:entity_type, :followup) }
    let(:custom_field) { create(:custom_field, :text, entity_type: entity_type, user: user, required: true) }
    let(:params) { { contact_id: contact.id, followup: { contact_id: contact.id, followup_type_id: followup_type.id, note: 'Note', when: now } } }
    let(:params2) { { contact_id: contact.id, followup: { contact_id: contact.id, followup_type_id: followup_type.id, note: 'Note', when: now }, custom_fields: { custom_field.id => '' } } }
    let(:params3) { { contact_id: contact.id, followup: { contact_id: contact.id, followup_type_id: nil, note: 'Note', when: now } } }

    it 'redirects anon' do
      post :create, params: { contact_id: 0 }
      expect(response).to have_http_status(:redirect)
    end

    it 'returns a valid response' do
      sign_in user
      expect {
        post :create, params: params
      }.to change { Followup.count }.by(1)
      expect(response).to redirect_to(contact_followups_path(contact))
    end

    it 'returns unauthorized for unowned contact' do
      sign_in user2
      expect {
        post :create, params: params
        expect(assigns(:contact)).to eq(nil)
        expect(response).to redirect_to(followups_path)
      }.to change { Followup.count }.by(0)
    end

    it 'invalid custom field returns an invalid response' do
      sign_in user
      expect {
        post :create, params: params2
      }.to change { FieldValue.count }.by(0)
      expect(response).to redirect_to(edit_contact_followup_path(contact, assigns(:followup)))
      expect(assigns(:followup).class).to eq(Followup)
    end

    it 'invalid followup returns an invalid response' do
      sign_in user
      expect {
        post :create, params: params3
      }.to change { Followup.count }.by(0)
      expect(response).to render_template(:new)
    end
  end

  describe 'GET edit' do
    let(:user) { create(:user) }
    let(:followup) { create(:followup, user: user) }
    let(:contact) { create(:contact, user: user, followups: [followup]) }

    it 'redirects anon' do
      get :edit, params: { contact_id: 0, id: 0 }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns success' do
      sign_in user
      get :edit, params: { contact_id: contact.id, id: followup.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:followup)).to eq(followup)
    end
  end

  describe 'POST update' do
    let(:user) { create(:user) }
    let(:contact) { create(:contact, user: user, followups: [followup]) }
    let(:followup_type) { create(:followup_type) }
    let(:now) { Time.current }
    let!(:entity_type) { create(:entity_type, :followup) }
    let(:custom_field) { create(:custom_field, :text, entity_type: entity_type, user: user, required: true) }
    let(:followup) { create(:followup, user: user) }

    describe 'with contact' do
      let(:params) { { contact_id: contact.id, id: followup.id, followup: { followup_type_id: followup_type.id, note: 'Note Updated', when: now }, custom_fields: { custom_field.id => 'value' } } }
      let(:params2) { { contact_id: contact.id, id: followup.id, followup: { followup_type_id: followup_type.id, note: 'Note Updated', when: now }, custom_fields: { custom_field.id => '' } } }
      let(:params3) { { contact_id: contact.id, id: followup.id, followup: { followup_type_id: followup_type.id, note: '', when: now }, custom_fields: { custom_field.id => 'value' } } }

      it 'redirects anon' do
        post :update, params: { contact_id: 0, id: 0 }
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'returns success' do
        sign_in user
        post :update, params: params
        expect(response).to redirect_to(edit_contact_followup_path(contact, followup))
      end

      it 'invalid custom field value returns invalid' do
        sign_in user
        post :update, params: params2
        expect(response).to render_template(:edit)
      end

      it 'invalid value returns invalid' do
        sign_in user
        post :update, params: params3
        expect(response).to render_template(:edit)
      end
    end

    describe 'without contact' do
      let(:params) { { id: followup.id, followup: { followup_type_id: followup_type.id, note: 'Updated', when: now }, custom_fields: { custom_field.id => 'value' } } }
      let(:params2) { { id: followup.id, followup: { followup_type_id: followup_type.id, note: 'Updated', when: now }, custom_fields: { custom_field.id => '' } } }
      let(:params3) { { id: followup.id, followup: { followup_type_id: followup_type.id, note: '', when: now }, custom_fields: { custom_field.id => 'value' } } }

      it 'redirects anon' do
        post :update, params: { id: 0 }
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'returns success' do
        sign_in user
        post :update, params: params
        expect(response).to redirect_to(edit_followup_path(followup))
      end

      it 'invalid custom field value returns invalid' do
        sign_in user
        post :update, params: params2
        expect(response).to render_template(:edit)
      end

      it 'invalid value returns invalid' do
        sign_in user
        post :update, params: params3
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'GET complete' do
    let(:user) { create(:user) }
    let(:followup) { create(:followup, user: user) }

    it 'redirects anon' do
      get :complete, xhr: true, params: { id: 0 }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns success' do
      sign_in user
      get :complete, xhr: true, params: { id: followup.id }
      expect(response).to render_template(:complete)
    end
  end
end
