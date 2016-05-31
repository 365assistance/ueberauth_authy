defmodule Ueberauth.Strategy.Authy.PhoneVerification do
  @moduledoc """
  Ueberauth strategy using the Phone Verification API

  Request phase requires user details; sends user a verification code via sms or call
  Callback phase requires user details and verification code and succeeds if code is valid
  """
end
