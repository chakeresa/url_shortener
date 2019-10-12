defmodule UrlShortenerWeb.Router do
  use UrlShortenerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", UrlShortenerWeb do
    pipe_through :api

    resources "/urls", UrlController
  end

  scope "/redirect", UrlShortenerWeb do
    get ":shortened_url", UrlController, :redirect_to_long_url
  end
end
