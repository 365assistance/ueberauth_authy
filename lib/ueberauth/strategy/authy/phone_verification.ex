defmodule Ueberauth.Strategy.Authy.PhoneVerification do
  @moduledoc """
  Ueberauth strategy using the Phone Verification API

  See https://docs.authy.com/phone_verification.html for details on the API

  Request phase requires user details; sends user a verification code via sms or call
  Callback phase requires user details and verification code and succeeds if code is valid

  Default arguments for :via, :country_code, :locale, and :custom_message can be passed to the module when configuring ueberauth:

  ```
  config :ueberauth, Ueberauth,
    base_path: "/api/auth",
    providers: [
      authy: { Ueberauth.Strategy.Authy.PhoneVerification, [
        via: "sms", country_code: "61"] }]
  ```
  """

  use Ueberauth.Strategy

  @doc """
  Handle initial request by requesting a verification code from Authy

  Requires :authy map in assigns containing :phone_number
  The :authy map may also optionally contain :via, :country_code, :locale and :custom_message
  Optional member may also be set in the strategy options as in the module documentation

  Uses [set_errors!](https://github.com/ueberauth/ueberauth/blob/v0.2.0/lib/ueberauth/strategies/helpers.ex#L109) on error, placing :ueberauth_failure in assigns.

  *Does nothing (passes conn as-is) if conn.status is not nil*

  See https://docs.authy.com/phone_verification.html#sending-the-verification-code
  """
  def handle_request!(conn = %{assigns: %{authy: authy = %{phone_number: _}}, status: nil}) do
    params = authy_with_defaults(conn) |> Map.take([:via, :phone_number, :country_code, :locale, :custom_message])
    case Authy.PhoneVerification.start(params) do
      {:ok, _} -> conn
      {:error, message} -> set_errors!(conn, [error("authy", message)])
    end
  end

  def handle_request!(conn) do
    conn
  end

  @doc """
  Handle callback by checking a verification code with Authy

  Requires :authy map in assigns containing :phone_number, :verification_code
  The :authy map may also optionally contain :country_code
  Optional member may also be set in the strategy options as in the module documentation

  Uses [set_errors!](https://github.com/ueberauth/ueberauth/blob/v0.2.0/lib/ueberauth/strategies/helpers.ex#L109) on error, placing :ueberauth_failure in assigns.

  *Does nothing (passes conn as-is) if conn.status is not nil*

  See https://docs.authy.com/phone_verification.html#verifying-the-verification-code
  """
  def handle_callback!(conn = %{assigns: %{authy: authy = %{phone_number: _, verification_code: _}}, status: nil}) do
    params = authy_with_defaults(conn) |> Map.take([:phone_number, :country_code, :verification_code])
    case Authy.PhoneVerification.check(authy) do
      {:ok, _} -> conn
      {:error, message} -> set_errors!(conn, [error("authy", message)])
    end
  end

  def handle_callback!(conn) do
    conn
  end

  defp authy_with_defaults(conn = %{assigns: %{authy: authy}}) do
    options(conn)
    |> Enum.into(%{})
    |> Map.merge(authy)
  end
end
