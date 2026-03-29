defmodule AeroSyncOpsWeb.AuthControllerTest do
  use AeroSyncOpsWeb.ConnCase, async: true

  import AeroSyncOps.Fixtures

  describe "POST /api/auth/login" do
    test "retorna token e dados básicos do usuário", %{conn: conn} do
      user = user_fixture(%{password: "SenhaLogin123!"})

      conn = post(conn, "/api/auth/login", %{email: user.email, password: "SenhaLogin123!"})
      response = json_response(conn, 200)

      assert is_binary(response["token"])
      assert response["user"]["id"] == user.id
      assert response["user"]["email"] == user.email
    end

    test "retorna 401 para credenciais inválidas", %{conn: conn} do
      user = user_fixture(%{password: "SenhaLogin123!"})

      conn = post(conn, "/api/auth/login", %{email: user.email, password: "senha_errada"})

      assert %{"error" => "Credenciais inválidas"} = json_response(conn, 401)
    end

    test "retorna 400 quando payload é inválido", %{conn: conn} do
      conn = post(conn, "/api/auth/login", %{})

      assert %{"error" => "email e password são obrigatórios"} = json_response(conn, 400)
    end
  end
end
