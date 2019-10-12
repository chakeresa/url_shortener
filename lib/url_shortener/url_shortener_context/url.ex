defmodule UrlShortener.UrlShortenerContext.Url do
  use Ecto.Schema
  import Ecto.Changeset

  schema "urls" do
    field :original, :string
    field :shortened, :string

    timestamps()
  end

  @doc false
  def changeset(url, attrs) do
    url
    |> cast(attrs, [:original, :shortened])
    |> validate_required([:original, :shortened])
  end
end
