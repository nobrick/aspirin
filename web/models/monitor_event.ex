defmodule Aspirin.MonitorEvent do
  use Aspirin.Web, :model

  schema "monitor_events" do
    field :addr, :string
    field :port, :integer
    field :name, :string
    field :type, :string

    timestamps
  end

  @required_fields ~w(addr port name)
  @optional_fields ~w(type)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
