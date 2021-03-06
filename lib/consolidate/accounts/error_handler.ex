defmodule Consolidate.Accounts.ErrorHandler do
  use ConsolidateWeb, :controller
  alias ConsolidateWeb.Router.Helpers, as: Routes
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    body = to_string(type)

    #conn
    #|> put_resp_content_type("text/plain")
    #|> send_resp(401, body)
    conn |> redirect(to: Routes.session_path(conn,:new))
  end
end
