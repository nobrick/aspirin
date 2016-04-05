defmodule Aspirin.MonitorEventController do
  use Aspirin.Web, :controller

  alias Aspirin.MonitorEvent

  plug :scrub_params, "monitor_event" when action in [:create, :update]

  def index(conn, _params) do
    monitor_events = Repo.all(MonitorEvent)
    render(conn, "index.html", monitor_events: monitor_events)
  end

  def new(conn, _params) do
    changeset = MonitorEvent.changeset(%MonitorEvent{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"monitor_event" => monitor_event_params}) do
    changeset = MonitorEvent.changeset(%MonitorEvent{}, monitor_event_params)

    case Repo.insert(changeset) do
      {:ok, _monitor_event} ->
        conn
        |> put_flash(:info, "Monitor event created successfully.")
        |> redirect(to: monitor_event_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    monitor_event = Repo.get!(MonitorEvent, id)
    render(conn, "show.html", monitor_event: monitor_event)
  end

  def edit(conn, %{"id" => id}) do
    monitor_event = Repo.get!(MonitorEvent, id)
    changeset = MonitorEvent.changeset(monitor_event)
    render(conn, "edit.html", monitor_event: monitor_event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "monitor_event" => monitor_event_params}) do
    monitor_event = Repo.get!(MonitorEvent, id)
    changeset = MonitorEvent.changeset(monitor_event, monitor_event_params)

    case Repo.update(changeset) do
      {:ok, monitor_event} ->
        conn
        |> put_flash(:info, "Monitor event updated successfully.")
        |> redirect(to: monitor_event_path(conn, :show, monitor_event))
      {:error, changeset} ->
        render(conn, "edit.html", monitor_event: monitor_event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    monitor_event = Repo.get!(MonitorEvent, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(monitor_event)

    conn
    |> put_flash(:info, "Monitor event deleted successfully.")
    |> redirect(to: monitor_event_path(conn, :index))
  end
end
