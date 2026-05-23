# frozen_string_literal: true

require "doorkeeper/openid_connect"
require_relative "redmine_oidc_provider/config"

gem_path = Gem.loaded_specs.fetch("doorkeeper-openid_connect").full_gem_path
require File.join(gem_path, "lib/doorkeeper/openid_connect/orm/active_record/access_grant")
require File.join(gem_path, "lib/doorkeeper/openid_connect/orm/active_record/request")
require File.join(gem_path, "app/controllers/doorkeeper/openid_connect/discovery_controller")
require File.join(gem_path, "app/controllers/doorkeeper/openid_connect/dynamic_client_registration_controller")
require File.join(gem_path, "app/controllers/doorkeeper/openid_connect/userinfo_controller")

RedmineOidcProvider::Config.apply!

module RedmineOidcProvider
  def self.install_active_record_extensions!
    access_grant_model = if Doorkeeper.config.respond_to?(:access_grant_model)
                           Doorkeeper.config.access_grant_model
                         else
                           Doorkeeper::AccessGrant
                         end

    unless access_grant_model.reflect_on_association(:openid_request)
      access_grant_model.prepend Doorkeeper::OpenidConnect::AccessGrant
    end
  end
end

Rails.application.config.to_prepare do
  RedmineOidcProvider.install_active_record_extensions!
end
