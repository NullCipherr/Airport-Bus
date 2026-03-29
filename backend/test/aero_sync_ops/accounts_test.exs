defmodule AeroSyncOps.AccountsTest do
  use AeroSyncOps.DataCase, async: true

  alias AeroSyncOps.Accounts
  import AeroSyncOps.Fixtures

  describe "authenticate/2" do
    test "retorna usuário e token quando credenciais são válidas" do
      user = user_fixture(%{password: "MinhaSenha123!"})

      assert {:ok, authenticated_user, token} = Accounts.authenticate(user.email, "MinhaSenha123!")
      assert authenticated_user.id == user.id
      assert is_binary(token)
      assert String.length(token) > 10
    end

    test "retorna erro para senha inválida" do
      user = user_fixture(%{password: "MinhaSenha123!"})

      assert {:error, :invalid_credentials} = Accounts.authenticate(user.email, "senha_errada")
    end
  end

  describe "verify_token/1" do
    test "aceita token assinado e retorna o usuário" do
      user = user_fixture()
      token = Phoenix.Token.sign(AeroSyncOpsWeb.Endpoint, "user auth", %{id: user.id, role: user.role})

      assert {:ok, token_user} = Accounts.verify_token(token)
      assert token_user.id == user.id
    end

    test "retorna não autorizado para token inválido" do
      assert {:error, :unauthorized} = Accounts.verify_token("token-invalido")
    end
  end
end
