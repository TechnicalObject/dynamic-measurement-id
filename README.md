# Dynamic Measurement ID

A Google Tag Manager variable template that returns the right GA4 Measurement ID for the page you are on. Production traffic gets your PROD ID; staging, preview, local and GTM Preview traffic gets your DEV ID, so test hits stay out of production reports.

## How it decides

1. If **DEV Measurement ID** is empty, the variable always returns the PROD ID.
2. If **Bypass DEV property ID while testing** is checked, the variable always returns the PROD ID.
3. If GTM Preview / debug mode is on, it returns the DEV ID.
4. Otherwise the page hostname decides:
   - **PROD hostnames (allowlist, fail-closed)** is filled in: only those exact hostnames get PROD. Every other host (staging, Cloudflare Pages / Netlify / Vercel previews, localhost, anything unknown) gets DEV. This is the recommended setup.
   - The allowlist is empty: hosts listed under **Staging Hostnames**, or matching the **RegEx value**, get DEV. Everything else gets PROD (fail-open).

Hostnames are compared case-insensitively and without the port. Subdomains are not matched automatically, so list `www.example.com` separately if you use it.

## Fields

| Field | Required | Description |
| --- | --- | --- |
| PROD Measurement ID | Yes | GA4 Measurement ID for production, `G-XXXXXXXXXX`. |
| (Optional) DEV Measurement ID | No | GA4 Measurement ID for everything that is not production. |
| PROD hostnames (allowlist, fail-closed) | No | Comma-separated list, for example `example.com, www.example.com`. |
| Manual list of domains or RegExp | No | Used only when the allowlist is empty. |
| Staging Hostnames | When "List manually" | One hostname per row. |
| RegEx value | When "Regex" | Tested against the hostname, for example `-stg\|localhost`. |
| Bypass DEV property ID while testing | No | Return PROD even in Preview, to check the production setup. |

## Usage

1. Add the template from the Community Template Gallery (Templates, Variable Templates, Search Gallery).
2. Create a variable from it and fill in the PROD ID, the DEV ID and your production hostnames.
3. Use the variable as the Measurement ID in your Google tag and GA4 event tags.

## Permissions

- **Reads container data**: to know whether GTM Preview / debug mode is on.
- **Reads URL** (host only): to read the page hostname.
- **Logs to console** (debug only): explains the decision while you are in Preview.

The template sends no data anywhere and sets no cookies.

## Issues

Report bugs and requests in [GitHub Issues](https://github.com/TechnicalObject/dynamic-measurement-id/issues).

## License

Apache 2.0, see [LICENSE](LICENSE).
