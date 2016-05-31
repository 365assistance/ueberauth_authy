defmodule Ueberauth.Strategy.Authy.PhoneVerification do
  @moduledoc """
  Ueberauth strategy using the Phone Verification API

  Request phase requires user details; sends user a verification code via sms or call
  Callback phase requires user details and verification code and succeeds if code is valid
  """

  use Ueberauth.Strategy

  @doc """
  Handle initial request by requesting a verification code from Authy

  Requires :authy map in assigns containing :via, :phone_number, :country_code
  :authy map may also optionally contain :locale and :custom_message

  Uses [set_errors!](https://github.com/ueberauth/ueberauth/blob/v0.2.0/lib/ueberauth/strategies/helpers.ex#L109) on error, placing :ueberauth_failure in assigns.

  See https://docs.authy.com/phone_verification.html#sending-the-verification-code
  """
  def handle_request!(conn = %{assigns: %{authy: authy = %{phone_number: _}}}) do
    params = authy_with_defaults(conn) |> Map.take([:via, :phone_number, :country_code, :locale, :custom_message])
    case Authy.PhoneVerification.start(params) do
      {:ok, _} -> conn
      {:error, message} -> set_errors!(conn, [error("authy", message)])
    end
  end

  @doc """
  Handle callback by checking a verification code with Authy

  Requires :authy map in assigns containing :phone_number, :country_code, :verification_code

  Uses [set_errors!](https://github.com/ueberauth/ueberauth/blob/v0.2.0/lib/ueberauth/strategies/helpers.ex#L109) on error, placing :ueberauth_failure in assigns.

  See https://docs.authy.com/phone_verification.html#verifying-the-verification-code
  """
  def handle_callback!(conn = %{assigns: %{authy: authy = %{phone_number: _, verification_code: _}}}) do
    params = authy_with_defaults(conn) |> Map.take([:phone_number, :country_code, :verification_code])
    case Authy.PhoneVerification.check(authy) do
      {:ok, _} -> conn
      {:error, message} -> set_errors!(conn, [error("authy", message)])
    end
  end

  defp authy_with_defaults(conn = %{assigns: %{authy: authy}}) do
    options(conn)
    |> Enum.into(%{})
    |> Map.merge(authy)
  end
end
