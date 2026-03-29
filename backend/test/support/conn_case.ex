defmodule AeroSyncOpsWeb.ConnCase do
  @moduledoc """
  Configuração base para testes de conexão HTTP.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      @endpoint AeroSyncOpsWeb.Endpoint

      import Plug.Conn
      import Phoenix.ConnTest
      import AeroSyncOpsWeb.ConnCase
    end
  end

  setup tags do
    AeroSyncOps.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
