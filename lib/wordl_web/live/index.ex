defmodule WordlWeb.WordlLive.Index do
  use WordlWeb, :live_view

  alias WordlWeb.Router.Helpers, as: Routes

  alias Wordl.Words
  import Ecto.Changeset

  @secret_word "crumb"

  def mount(_params, _session, socket), do: {:ok, assign(socket, match?: false)}

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def handle_event(
        "submit_word",
        %{"word_search" => form_params},
        socket
      ) do
    case word_changeset(form_params).valid? do
      true ->
        {:noreply,
         socket
         |> push_patch(
           to: Routes.wordl_index_path(socket, :index, word_attempt: form_params["word_attempt"])
         )}
    end
  end

  defp word_changeset(attrs) do
    types = %{
      word_attempt: :string
    }

    {%{}, types}
    |> cast(attrs, Map.keys(types))
    |> validate_required([:word_attempt])
    |> validate_length(:word_attempt, min: 5, max: 5)
    |> validate_is_word(:word_attempt)
    |> validate_word_match()
    |> IO.inspect(label: 'INSERT LABEL')
  end

  # Check for exact word match
  # if match --> return success
  # if !match --> attempt to find successful letters
  # search for exact letter matches
  # search for letter existence in other position

  defp validate_word_match(changeset) do
    word = get_field(changeset, :word_attempt)

    with true <- exact_match?(@secret_word, word) do
      changeset
    else
      false ->
        add_error(changeset, :word_attempt, "Word is not an exact match")
    end
  end

  defp exact_match?(word, word), do: true
  defp exact_match?(_, _), do: false

  defp validate_is_word(changeset, field) do
    validate_change(changeset, field, fn field, word ->
      case Words.is_word?(word) do
        true ->
          []

        false ->
          [{field, "Word not found."}]
      end
    end)
  end
end
