defmodule UrlShortenerWeb.UrlControllerTest do
  use UrlShortenerWeb.ConnCase

  alias UrlShortener.UrlShortenerContext
  alias UrlShortener.UrlShortenerContext.Url

  @create_attrs %{
    original: "https://crouton.net",
    shortened: "some shortened"
  }
  @update_attrs %{
    original: "https://en.wikipedia.org/wiki/Cat",
    shortened: "some updated shortened"
  }
  @invalid_attrs %{original: nil, shortened: nil}

  def fixture(:url) do
    {:ok, url} = UrlShortenerContext.create_url(@create_attrs)
    url
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all urls", %{conn: conn} do
      conn = get(conn, Routes.url_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create url" do
    test "renders url when data is valid", %{conn: conn} do
      conn = post(conn, Routes.url_path(conn, :create), url: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.url_path(conn, :show, id))

      assert %{
               "id" => id,
               "original" => "https://crouton.net",
               "shortened" => "some shortened"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.url_path(conn, :create), url: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update url" do
    setup [:create_url]

    test "renders url when data is valid", %{conn: conn, url: %Url{id: id} = url} do
      conn = put(conn, Routes.url_path(conn, :update, url), url: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.url_path(conn, :show, id))

      assert %{
               "id" => id,
               "original" => "https://en.wikipedia.org/wiki/Cat",
               "shortened" => "some updated shortened"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, url: url} do
      conn = put(conn, Routes.url_path(conn, :update, url), url: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete url" do
    setup [:create_url]

    test "deletes chosen url", %{conn: conn, url: url} do
      conn = delete(conn, Routes.url_path(conn, :delete, url))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.url_path(conn, :show, url))
      end
    end
  end

  describe "redirect to long url" do
    setup [:create_url]

    test "redirects to the long url given the short url", %{conn: conn, url: url} do
      conn = get(conn, Routes.url_path(conn, :redirect_to_long_url, url.shortened))

      assert redirected_to(conn, 302) =~ url.original
    end
  end

  defp create_url(_) do
    url = fixture(:url)
    {:ok, url: url}
  end
end
