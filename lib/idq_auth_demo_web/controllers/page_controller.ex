defmodule IdqAuthDemoWeb.PageController do
  use IdqAuthDemoWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
