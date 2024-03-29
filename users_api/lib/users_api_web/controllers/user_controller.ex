defmodule UsersApiWeb.UserController do
  use UsersApiWeb, :controller

  alias Ecto.UUID
  alias UsersApi.Admin
  alias UsersApi.Admin.User

  action_fallback UsersApiWeb.FallbackController

  def index(conn, _params) do
    users = Admin.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, user_params) do
    with {:ok, %User{} = user} <- Admin.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    else
      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> render(:bad_request, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, _} <- UUID.dump(id) do
      try do
        user = Admin.get_user!(id)
        render(conn, :show, user: user)

      rescue
        Ecto.NoResultsError -> render(conn, :not_found, id: id)
      end

      else
        :error -> render(conn, :not_found, id: id)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Admin.get_user!(id)

    with {:ok, %User{} = user} <- Admin.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Admin.get_user!(id)

    with {:ok, %User{}} <- Admin.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
