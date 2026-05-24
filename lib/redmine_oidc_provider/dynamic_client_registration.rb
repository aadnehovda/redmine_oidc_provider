# frozen_string_literal: true

module RedmineOidcProvider
  module DynamicClientRegistration
    private

    def application_params(registration)
      super.tap do |attributes|
        attributes[:scopes] =
          params[:scope].presence || default_dcr_scopes
      end
    end

    def default_dcr_scopes
      config = Doorkeeper.configuration
      (config.default_scopes + config.optional_scopes).to_s
    end
  end
end
