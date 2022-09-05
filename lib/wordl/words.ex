defmodule Wordl.Words do
  alias HTTPoison

  def base_url(), do: Application.get_env(:wordl, :oxford_base_url)
  def api_id(), do: Application.get_env(:wordl, :oxford_api_id)
  def api_key(), do: Application.get_env(:wordl, :oxford_api_key)

  def api_url(word),
    do: base_url() <> "/entries/en-us/#{String.downcase(word)}"

  def is_word?(word) do
    with {:ok, %{status_code: 200}} = response <-
           HTTPoison.get(api_url(word), app_id: api_id(), app_key: api_key()),
         IO.inspect(response, label: 'INSERT LABEL') do
      true
    else
      _ -> false
    end
  end
end
