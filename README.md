# UeberauthAuthy

[Ueberauth](https://github.com/ueberauth/ueberauth) strategy using the [Authy Phone Verification API](https://docs.authy.com/phone_verification.html).

## Installation

  1. Add ueberauth_authy to your list of dependencies in `mix.exs`:

        def deps do
          [{:ueberauth_authy, github: "365assistance/ueberauth_authy"}]
        end

  2. Ensure ueberauth_authy is started before your application:

        def application do
          [applications: [:ueberauth_authy]]
        end
