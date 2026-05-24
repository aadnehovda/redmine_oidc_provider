# frozen_string_literal: true

require "openssl"

module RedmineOidcProvider
  module Config
    module_function

    def apply!
      Doorkeeper::OpenidConnect.configure do
        issuer do |_resource_owner, _application, request|
          RedmineOidcProvider::Config.issuer(request)
        end

        signing_key do
          RedmineOidcProvider::Config.signing_key
        end

        subject_types_supported [:public]

        subject do |resource_owner, _application|
          resource_owner.id.to_s
        end

        resource_owner_from_access_token do |access_token|
          User.active.find_by(id: access_token.resource_owner_id)
        end

        auth_time_from_resource_owner do |_resource_owner|
          Time.current
        end

        reauthenticate_resource_owner do |_resource_owner, return_to|
          redirect_to signin_path(back_url: return_to)
        end

        select_account_for_resource_owner do |_resource_owner, return_to|
          redirect_to return_to
        end

        dynamic_client_registration RedmineOidcProvider::Config.dcr_enabled?
      end
    end

    def issuer(request)
      explicit = ENV["REDMINE_OIDC_PROVIDER_ISSUER"].to_s.strip
      return explicit unless explicit.empty?

      request&.base_url || Redmine::Utils::relative_url_root.presence || Setting.protocol + "://" + Setting.host_name
    end

    def signing_key
      file = ENV["REDMINE_OIDC_PROVIDER_SIGNING_KEY_FILE"].to_s.strip
      return File.read(file) unless file.empty?

      value = ENV["REDMINE_OIDC_PROVIDER_SIGNING_KEY"].to_s
      return value unless value.empty?

      ephemeral_signing_key
    end

    def dcr_enabled?
      truthy?(ENV.fetch("REDMINE_OIDC_PROVIDER_DCR_ENABLED", "false"))
    end

    def dcr_default_scopes
      ENV["REDMINE_OIDC_PROVIDER_DCR_DEFAULT_SCOPES"].to_s.strip
    end

    def truthy?(value)
      %w[1 true yes on].include?(value.to_s.downcase)
    end

    def ephemeral_signing_key
      @ephemeral_signing_key ||= OpenSSL::PKey::RSA.generate(2048).to_pem
    end
  end
end
