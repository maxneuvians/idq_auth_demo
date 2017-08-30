defmodule IdqAuthDemo.AuthPlug do
    import Plug.Conn

     def init(opts), do: opts

     def call(conn, _opts) do
        case get_session(conn, :current_user) do
          nil ->
            conn
            |> put_resp_header("location", "/login")
            |> send_resp(302, "")
          current_user ->
            assign(conn, :current_user, current_user)
        end
     end
end
