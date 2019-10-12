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
    |> validate_url(:original)
    |> unique_constraint(:original)
    |> unique_constraint(:shortened)
  end

  def validate_url(changeset, original) do
    validate_change(changeset, original, fn _, original ->
      %{host: host, scheme: scheme} = URI.parse(original)

      if host && scheme do
        []
      else
        [original: "must be valid url"]
      end
    end)
  end
end
