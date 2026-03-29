defmodule AeroSyncOps.Fixtures do
  @moduledoc """
  Helpers de criação de dados para testes.
  """

  alias AeroSyncOps.Accounts

  def unique_email, do: "user#{System.unique_integer([:positive])}@aerosync.test"

  def user_fixture(attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: "Usuário Teste",
        email: unique_email(),
        role: :operador,
        password: "SenhaSegura123!"
      })

    {:ok, user} = Accounts.create_user(attrs)
    user
  end
end
