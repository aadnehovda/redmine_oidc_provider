# frozen_string_literal: true

Doorkeeper::OpenidConnect::Rails::Routes.install!

RedmineApp::Application.routes.draw do
  use_doorkeeper_openid_connect
end
