# Redmine OIDC Provider

Experimental Redmine 6.1 plugin that wires `doorkeeper-openid_connect` into
Redmine's built-in Doorkeeper OAuth provider.

The current goal is to make Redmine usable as an OAuth/OIDC authorization server
for hosted MCP servers and other OAuth clients. It adds OpenID Connect discovery,
userinfo support, and optional Dynamic Client Registration.

## Status

This is early test code extracted from a Redmine 6.1 deployment. Review the
configuration and behavior before using it outside a test environment.

## Requirements

- Redmine 6.1 or newer
- Redmine's built-in Doorkeeper OAuth provider
- Ruby/Rails versions matching Redmine 6.1

The plugin currently pins `doorkeeper-openid_connect` to a known working git
commit in `Gemfile`.

## Install

Clone this repository into Redmine's `plugins` directory:

```sh
git clone <repository-url> plugins/redmine_oidc_provider
```

Install plugin dependencies and run migrations using your normal Redmine
deployment workflow.

For Docker-based Redmine images, the usual pattern is to copy the plugin into
`plugins/redmine_oidc_provider`, run `bundle install`, and set
`REDMINE_PLUGINS_MIGRATE=1` during deployment.

## Configuration

All configuration is environment-driven. Do not commit secrets.

| Variable | Purpose |
| --- | --- |
| `REDMINE_OIDC_PROVIDER_ISSUER` | Optional explicit issuer URL. Defaults to request base URL / Redmine settings. |
| `REDMINE_OIDC_PROVIDER_SIGNING_KEY_FILE` | Path to a PEM signing key file. Preferred for deployments. |
| `REDMINE_OIDC_PROVIDER_SIGNING_KEY` | PEM signing key value. Useful for local tests only. |
| `REDMINE_OIDC_PROVIDER_DCR_ENABLED` | Enables Dynamic Client Registration when set to `true`, `1`, `yes`, or `on`. |

If no signing key is configured, the plugin generates an ephemeral RSA key at
boot. That is only suitable for local testing because tokens/key material will
change on restart.

## Endpoints

The plugin installs the routes provided by `doorkeeper-openid_connect`,
including:

- `/.well-known/oauth-authorization-server`
- `/.well-known/openid-configuration`
- `/oauth/registration` when Dynamic Client Registration is enabled

OAuth authorization, token, and revocation endpoints remain Redmine/Doorkeeper
endpoints.

## Notes

This plugin makes Redmine act as an OIDC/OAuth provider. It is separate from
plugins that make Redmine authenticate users against an external company IdP.

## License

This plugin is licensed under the GNU General Public License version 2, matching
Redmine itself. See [LICENSE](LICENSE).
