defmodule IdqAuthDemoWeb.BrokerChannel do
  use IdqAuthDemoWeb, :channel

  require Logger

  def join("broker:lobby", _payload, socket) do
    {:ok, socket}
  end

  def join("broker:" <> _username, _payload, socket) do
    {:ok, socket}
  end

  def handle_in("push", %{"title" => title, "body" => body}, socket) do
    username = socket.topic |> String.replace("broker:", "")
    {:ok, _pid, id} = IdqAuth.Delegated.push(username, title, body)
    check_push_result(0, id, username, 0)
    {:reply, {:ok, %{id: id}}, socket}
  end

  defp check_push_result(0, id, username, attempt) do
    Logger.info "Checking"
    if attempt < 10 do
      :timer.sleep(3_000)
      check_push_result(IdqAuth.Delegated.Observer.result(id), id, username, attempt + 1)
    else
      IdqAuthDemoWeb.Endpoint.broadcast "broker:" <> username, "push_result", %{result: "Timed out"}
    end
  end

  defp check_push_result(%{"description" => "accept"}, _id, username, _attempt) do
    IdqAuthDemoWeb.Endpoint.broadcast "broker:" <> username, "push_result", %{result: "Accepted"}
  end

  defp check_push_result(%{"description" => "decline"}, _id, username, _attempt) do
    IdqAuthDemoWeb.Endpoint.broadcast "broker:" <> username, "push_result", %{result: "Declined"}
  end


end
