# UeberauthAuthy

[![Build status](https://badge.buildkite.com/d00ca89c5b7bb113af3b4423be78b2eb480a9b25a5a9dd8511.svg)](https://buildkite.com/365-assistance-pty-ltd/ueberauthauthy)

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

  3. Configure ueberauth and the PhoneVerification strategy

    config :ueberauth, Ueberauth,
      base_path: "/api/auth",
      providers: [
        authy: { Ueberauth.Strategy.Authy.PhoneVerification, [
          via: "sms", country_code: "61"] }]

  4. Configure Authy

        config :authy,
          api_key: System.get_env("AUTHY_API_KEY")

## Usage

You must add a map `authy` to `conn.assigns` that contains the requisite members for each step; see the strategy docs for details. The reason for this is to avoid having an endpoint to which you can just pass a `phone_number` and allow spamming of people's phones using your twilio account.

Setting `conn.status` to anything but nil will skip the strategy.

### Example

```
plug :lookup_phone_number
plug Ueberauth

... <callbacks etc>

defp lookup_phone_number(conn = %{params: ${user_id: user_id}}) do
  case User.find(user_id) do
    user = %User{} -> assign(:authy, %{phone_number: user.phone_number})
    _ -> put_status(404)
  end
end

...
```
