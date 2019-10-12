defmodule UrlShortener.UrlShortenerContextTest do
  use UrlShortener.DataCase

  alias UrlShortener.UrlShortenerContext

  describe "urls" do
    alias UrlShortener.UrlShortenerContext.Url

    @valid_attrs %{original: "some original", shortened: "some shortened"}
    @update_attrs %{original: "some updated original", shortened: "some updated shortened"}
    @invalid_attrs %{original: nil, shortened: nil}

    def url_fixture(attrs \\ %{}) do
      {:ok, url} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UrlShortenerContext.create_url()

      url
    end

    test "list_urls/0 returns all urls" do
      url = url_fixture()
      assert UrlShortenerContext.list_urls() == [url]
    end

    test "get_url!/1 returns the url with given id" do
      url = url_fixture()
      assert UrlShortenerContext.get_url!(url.id) == url
    end

    test "create_url/1 with valid data creates a url" do
      assert {:ok, %Url{} = url} = UrlShortenerContext.create_url(@valid_attrs)
      assert url.original == "some original"
      assert url.shortened == "some shortened"
    end

    test "create_url/1 with duplicate original url returns error changeset" do
      attrs1 = %{original: 'original1', shortened: 'shortened1'}
      UrlShortenerContext.create_url(attrs1)
      attrs2 = %{original: 'original1', shortened: 'shortened2'}

      assert {:error, %Ecto.Changeset{}} = UrlShortenerContext.create_url(attrs2)
    end

    test "create_url/1 with duplicate shortened url returns error changeset" do
      attrs1 = %{original: 'original1', shortened: 'shortened1'}
      UrlShortenerContext.create_url(attrs1)
      attrs2 = %{original: 'original2', shortened: 'shortened1'}

      assert {:error, %Ecto.Changeset{}} = UrlShortenerContext.create_url(attrs2)
    end

    test "create_url/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UrlShortenerContext.create_url(@invalid_attrs)
    end

    test "update_url/2 with valid data updates the url" do
      url = url_fixture()
      assert {:ok, %Url{} = url} = UrlShortenerContext.update_url(url, @update_attrs)
      assert url.original == "some updated original"
      assert url.shortened == "some updated shortened"
    end

    test "update_url/2 with invalid data returns error changeset" do
      url = url_fixture()
      assert {:error, %Ecto.Changeset{}} = UrlShortenerContext.update_url(url, @invalid_attrs)
      assert url == UrlShortenerContext.get_url!(url.id)
    end

    test "delete_url/1 deletes the url" do
      url = url_fixture()
      assert {:ok, %Url{}} = UrlShortenerContext.delete_url(url)
      assert_raise Ecto.NoResultsError, fn -> UrlShortenerContext.get_url!(url.id) end
    end

    test "change_url/1 returns a url changeset" do
      url = url_fixture()
      assert %Ecto.Changeset{} = UrlShortenerContext.change_url(url)
    end

    test "get_long_url/1 returns the long url given the short url" do
      url = url_fixture()
      {:ok, short_url} = Map.fetch(url, :shortened)
      {:ok, long_url} = Map.fetch(url, :original)
      assert UrlShortenerContext.get_long_url(short_url) == long_url
    end
  end
end
