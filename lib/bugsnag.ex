defmodule Bugsnag do
  @notify_url "https://notify.bugsnag.com"
  @request_headers [{"Content-Type", "application/json"}]

  alias Bugsnag.Payload
  use HTTPoison.Base

  # Public

  # Currently we only support reporting exceptions.
  def report(exception, options \\ []) do
    spawn fn ->
      post(@notify_url,
           Payload.new(exception, stacktrace, options) |> to_json,
           @request_headers)
    end
  end

  # Private
  defp to_json(payload) do
    payload
    |> JSEX.encode
    |> elem(1)
  end
  defp stacktrace, do: System.stacktrace
end
