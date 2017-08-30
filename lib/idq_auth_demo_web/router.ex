defmodule IdqAuthDemoWeb.Router do
  use IdqAuthDemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug IdqAuthDemo.AuthPlug
  end

  pipeline :idq do
    plug IdqAuth.Plug
  end

  scope "/", IdqAuthDemoWeb do
    pipe_through :browser
    pipe_through :idq

    get "/login", LoginController, :index
  end

  scope "/", IdqAuthDemoWeb do
    pipe_through :browser
    pipe_through :auth

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", IdqAuthDemoWeb do
  #   pipe_through :api
  # end
end
