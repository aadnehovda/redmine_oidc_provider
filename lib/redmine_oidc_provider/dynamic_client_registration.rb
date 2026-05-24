# frozen_string_literal: true

module RedmineOidcProvider
  module DynamicClientRegistration
    private

    def application_params(registration)
      super.tap do |attributes|
        attributes[:scopes] =
          params[:scope].presence || Doorkeeper.configuration.scopes.to_s
      end
    end
  end
end
