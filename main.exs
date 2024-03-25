Code.compile_file("tagged_tuple.exs", __DIR__)

defmodule Playground do
  alias TaggedTuple, as: TT

  @users [
    %{id: 1, first: "bob", last: "smith"},
    %{id: 2, first: "sam", last: nil},
    %{id: 3, first: "jill", last: "adams"}
  ]

  @spec get_user_by_id(String.t()) :: {:ok, map()} | {:error, :not_found}
  def get_user_by_id(user_id) do
    case Enum.find(@users, &(&1.id == user_id)) do
      user when is_map(user) ->
        {:ok, user}

      _ ->
        {:error, :not_found}
    end
  end

  @spec get_full_name(map()) :: {:ok, String.t()} | {:error, :last_name_missing}
  def get_full_name(%{last: nil}), do: {:error, :last_name_missing}

  def get_full_name(%{last: last, first: first}) do
    {:ok, "#{last}, #{first}"}
  end

  def tagged_tuple_print(user_id) do
    user_id
    |> Playground.get_user_by_id()
    |> TT.and_then(&Playground.get_full_name/1)
    |> TT.map(&String.capitalize/1)
    |> IO.inspect(label: "user_id #{user_id} - ")
  end

  def with_statement_print(user_id) do
    with {:ok, user} <- Playground.get_user_by_id(user_id),
         {:ok, full_name} <- Playground.get_full_name(user),
         full_name_capitalized <- String.capitalize(full_name) do
      {:ok, full_name_capitalized}
    else
      err -> err
    end
    |> IO.inspect(label: "user_id #{user_id} - ")
  end
end

Playground.tagged_tuple_print(1)
Playground.tagged_tuple_print(2)
Playground.tagged_tuple_print(3)
Playground.tagged_tuple_print(4)

IO.puts("--------------------------")

Playground.with_statement_print(1)
Playground.with_statement_print(2)
Playground.with_statement_print(3)
Playground.with_statement_print(4)
