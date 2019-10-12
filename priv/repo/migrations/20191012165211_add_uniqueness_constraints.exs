defmodule UrlShortener.Repo.Migrations.AddUniquenessConstraints do
  use Ecto.Migration

  def change do
    create unique_index(:urls, [:original])
    create unique_index(:urls, [:shortened])
  end
end
