# frozen_string_literal: true

require "redmine"
require_relative "lib/redmine_oidc_provider"

Redmine::Plugin.register :redmine_oidc_provider do
  name "Redmine OIDC Provider"
  author "Community"
  description "Adds OpenID Connect discovery and Dynamic Client Registration to Redmine's built-in Doorkeeper provider."
  version "0.1.3"
  requires_redmine version_or_higher: "6.1.0"
end
