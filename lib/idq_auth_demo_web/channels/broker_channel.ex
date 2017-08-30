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
    IdqAuth.Delegated.push(username, title, body, &check_push_result/2, %{username: username})
    {:reply, {:ok, %{}}, socket}
  end

  def handle_in("start_challenge", _params, socket) do
    username = socket.topic |> String.replace("broker:", "")
    {:ok, challenge, _pid} = IdqAuth.Implicit.start_challenge(&check_challenge_result/2, true, %{username: username})
    {:reply, {:ok, %{challenge: Base.encode64(challenge)}}, socket}
  end

  def check_challenge_result(params, %{username: username}) do
    IdqAuthDemoWeb.Endpoint.broadcast "broker:" <> username, "challenge_result", params
  end

  def check_push_result(%{"description" => "accept"}, %{username: username}) do
    IdqAuthDemoWeb.Endpoint.broadcast "broker:" <> username, "push_result", %{result: "Accepted"}
  end

  def check_push_result(%{"description" => "decline"}, %{username: username}) do
    IdqAuthDemoWeb.Endpoint.broadcast "broker:" <> username, "push_result", %{result: "Declined"}
  end
end
