# =============================================================
# AeroSync Ops
# Autor: Andrei Roberto da Costa
# Data: 2026-03-27
# Hora: 15:37:28 -03
# Arquivo: backend/lib/aero_sync_ops/accounts.ex
# =============================================================
defmodule AeroSyncOps.Accounts do
  import Ecto.Query, warn: false

  alias AeroSyncOps.Repo
  alias AeroSyncOps.Accounts.User

  def list_users, do: Repo.all(User)

  def get_user!(id), do: Repo.get!(User, id)

  def get_by_email(email), do: Repo.get_by(User, email: email)

  def create_user(attrs), do: %User{} |> User.changeset(attrs) |> Repo.insert()

  def authenticate(email, password) do
    case get_by_email(email) do
      nil -> {:error, :invalid_credentials}
      user ->
        if Bcrypt.verify_pass(password, user.password_hash) do
          token = Phoenix.Token.sign(AeroSyncOpsWeb.Endpoint, "user auth", %{id: user.id, role: user.role})
          {:ok, user, token}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  def verify_token(token) do
    case Phoenix.Token.verify(AeroSyncOpsWeb.Endpoint, "user auth", token, max_age: 86_400) do
      {:ok, %{"id" => id}} -> {:ok, get_user!(id)}
      {:ok, %{id: id}} -> {:ok, get_user!(id)}
      _ -> {:error, :unauthorized}
    end
  end
end
