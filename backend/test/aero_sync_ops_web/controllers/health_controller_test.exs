defmodule AeroSyncOpsWeb.HealthControllerTest do
  use AeroSyncOpsWeb.ConnCase, async: true

  import AeroSyncOps.Fixtures

  describe "GET /api/health" do
    test "bloqueia requisição sem token", %{conn: conn} do
      conn = get(conn, "/api/health")

      assert %{"error" => "Não autorizado"} = json_response(conn, 401)
    end

    test "retorna status ok para usuário autenticado", %{conn: conn} do
      user = user_fixture()
      token = Phoenix.Token.sign(AeroSyncOpsWeb.Endpoint, "user auth", %{id: user.id, role: user.role})

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> get("/api/health")

      assert %{"status" => "ok", "service" => "Airport Bus API"} = json_response(conn, 200)
    end
  end
end
