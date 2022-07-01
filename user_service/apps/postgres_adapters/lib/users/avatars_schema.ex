defmodule Users.AvatarsSchema do
  use Ecto.Schema

  alias Users.UsersSchema

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "avatars" do
    field :image, :string
    field :created, :utc_datetime
    belongs_to :users, UsersSchema, foreign_key: :user_id
  end
end
