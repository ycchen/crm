require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do

  describe 'GET #google_oauth2' do

    it 'redirects anon' do
      # @request.env['devise.mapping'] = Devise.mappings[:user]
      # @request.env['omniauth.auth'] = {}
      # get :google_oauth2
      #expect(response).to redirect_to(new_user_session_path)
    end

  end

  describe 'GET #facebook' do

  end

end
