require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe 'GET index' do
    let(:user) { create(:user) }

    it 'redirects anon' do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to contacts' do
      sign_in user
      get :index
      expect(response).to redirect_to(contacts_path)
    end
  end

  describe 'GET logout' do
    let(:user) { create(:user) }

    it 'redirects to www_url' do
      sign_in user
      get :logout
      expect(response).to be_redirect
    end
  end
end
