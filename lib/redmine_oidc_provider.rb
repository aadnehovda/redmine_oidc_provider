# frozen_string_literal: true

require "doorkeeper/openid_connect"
require_relative "redmine_oidc_provider/config"

gem_path = Gem.loaded_specs.fetch("doorkeeper-openid_connect").full_gem_path
require File.join(gem_path, "app/controllers/doorkeeper/openid_connect/discovery_controller")
require File.join(gem_path, "app/controllers/doorkeeper/openid_connect/dynamic_client_registration_controller")
require File.join(gem_path, "app/controllers/doorkeeper/openid_connect/userinfo_controller")

RedmineOidcProvider::Config.apply!
