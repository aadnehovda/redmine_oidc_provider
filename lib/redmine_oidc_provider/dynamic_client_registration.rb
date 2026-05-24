# frozen_string_literal: true

module RedmineOidcProvider
  module DynamicClientRegistration
    private

    def application_params(registration)
      super.tap do |attributes|
        attributes[:scopes] =
          params[:scope].presence || RedmineOidcProvider::Config.dcr_default_scopes
      end
    end
  end
end
