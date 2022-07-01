defmodule Users.Repo.Migrations.CreateAvatars do
  use Ecto.Migration

  def change do
    create table(:avatars, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all)
      add :created, :utc_datetime
      add :image, :bytea
    end

  end
end
