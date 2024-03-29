defmodule UrlShortenerWeb.UrlController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.UrlShortenerContext
  alias UrlShortener.UrlShortenerContext.Url

  action_fallback UrlShortenerWeb.FallbackController

  def index(conn, _params) do
    urls = UrlShortenerContext.list_urls()
    render(conn, "index.json", urls: urls)
  end

  def create(conn, %{"url" => url_params}) do
    with {:ok, %Url{} = url} <- UrlShortenerContext.create_url(url_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.url_path(conn, :show, url))
      |> render("show.json", url: url)
    end
  end

  def show(conn, %{"id" => id}) do
    url = UrlShortenerContext.get_url!(id)
    render(conn, "show.json", url: url)
  end

  def update(conn, %{"id" => id, "url" => url_params}) do
    url = UrlShortenerContext.get_url!(id)

    with {:ok, %Url{} = url} <- UrlShortenerContext.update_url(url, url_params) do
      render(conn, "show.json", url: url)
    end
  end

  def delete(conn, %{"id" => id}) do
    url = UrlShortenerContext.get_url!(id)

    with {:ok, %Url{}} <- UrlShortenerContext.delete_url(url) do
      send_resp(conn, :no_content, "")
    end
  end

  def redirect_to_long_url(conn, %{"shortened_url" => shortened_url}) do
    long_url = UrlShortenerContext.get_long_url(shortened_url)
    redirect(conn, external: long_url)
  end
end
