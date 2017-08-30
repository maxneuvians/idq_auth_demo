defmodule IdqAuthDemoWeb.LoginController do
  use IdqAuthDemoWeb, :controller

  def index(conn, _params) do
    if %{"username" => username, "email" => email} = conn.assigns.idq_user do
      conn = put_session(conn, :current_user, conn.assigns.idq_user)
    end

    redirect conn, to: "/"
  end
end
