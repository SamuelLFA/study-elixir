defmodule UsersApiWeb.UserJSON do
  alias UsersApi.Admin.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      address: user.address
    }
  end

  def bad_request(%{changeset: changeset}) do
    %{
      errors: Enum.map(changeset.errors, fn({key, {reason, _}}) -> "#{key}: #{reason}" end)
    }
  end

  def not_found(%{id: id}) do
    %{
      error: "id: #{id} not found"
    }
  end
end
