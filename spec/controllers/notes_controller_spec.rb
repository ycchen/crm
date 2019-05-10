require 'rails_helper'

RSpec.describe NotesController, type: :controller do

  describe 'GET index' do
    let(:user) { create(:user) }
    let(:note) { build(:note) }
    let(:contact) { create(:contact, user: user, notes: [note]) }

    it 'redirects anon' do
      get :index, params: { contact_id: 0 }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns success' do
      sign_in user
      get :index, params: { contact_id: contact.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:contact)).to eq(contact)
      expect(assigns(:notes)).to eq([note])
    end
  end

  describe 'GET new' do
    let(:user) { create(:user) }
    let(:contact) { create(:contact, user: user) }

    it 'redirects anon' do
      get :new, params: { contact_id: 0 }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'returns success' do
      sign_in user
      get :new, params: { contact_id: contact.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:contact)).to eq(contact)
      expect(assigns(:note).class).to eq(Note)
      expect(assigns(:note).user).to eq(user)
    end
  end

  describe 'POST create' do
    let(:user) { create(:user) }
    let(:contact) { create(:contact, user: user) }
    let(:params) { { contact_id: contact.id, note: { note: 'Note goes here' } } }

    it 'redirects anon' do
      post :create, params: { contact_id: 0, note: { note: '' } }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'creates note' do
      sign_in user
      expect {
        post :create, params: params
      }.to change { Note.count }.by(1)
      expect(response).to redirect_to(contact_notes_path(contact_id: contact.id))
    end

    it 'fails to create a null note' do
      sign_in user
      params[:note][:note] = nil
      expect {
        post :create, params: params
      }.to change { Note.count }.by(0)
      expect(response).to render_template(:new)
    end

    it 'fails to create a blank note' do
      sign_in user
      params[:note][:note] = ''
      expect {
        post :create, params: params
      }.to change { Note.count }.by(0)
      expect(response).to render_template(:new)
    end
  end

  describe 'GET edit' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:note) { build(:note) }
    let(:contact) { create(:contact, user: user, notes: [note]) }
    let(:params) { { contact_id: contact.id, id: note.id } }

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
      expect(assigns(:note)).to eq(note)
      expect(response).to render_template(:edit)
    end

    it 'returns unauthorized for unowned contact' do
      sign_in user2
      get :edit, xhr: true, params: params
      expect(assigns(:contact)).to eq(nil)
      expect(assigns(:note)).to eq(nil)
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET cancel_edit' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:note) { build(:note) }
    let(:contact) { create(:contact, user: user, notes: [note]) }
    let(:params) { { contact_id: contact.id, id: note.id } }

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
      expect(assigns(:note)).to eq(note)
      expect(response).to render_template(:cancel_edit)
    end

    it 'returns unauthorized for unowned contact' do
      sign_in user2
      get :cancel_edit, xhr: true, params: params
      expect(assigns(:contact)).to eq(nil)
      expect(assigns(:note)).to eq(nil)
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST update' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:note) { build(:note) }
    let(:contact) { create(:contact, user: user, notes: [note]) }
    let(:params) { { contact_id: contact.id, id: note.id, note: { note: 'Updated note goes here' } } }

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
      expect(assigns(:contact)).to eq(contact)
      expect(assigns(:note)).to eq(note)
      expect(response).to render_template(:update)
    end

    it 'returns unauthorized for unowned contact' do
      sign_in user2
      post :update, xhr: true, params: params
      expect(assigns(:contact)).to eq(nil)
      expect(assigns(:note)).to eq(nil)
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
