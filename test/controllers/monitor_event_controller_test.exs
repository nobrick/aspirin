defmodule Aspirin.MonitorEventControllerTest do
  use Aspirin.ConnCase

  alias Aspirin.MonitorEvent
  @valid_attrs %{addr: "some content", name: "some content", port: 42, type: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, monitor_event_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing monitor events"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, monitor_event_path(conn, :new)
    assert html_response(conn, 200) =~ "New monitor event"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, monitor_event_path(conn, :create), monitor_event: @valid_attrs
    assert redirected_to(conn) == monitor_event_path(conn, :index)
    assert Repo.get_by(MonitorEvent, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, monitor_event_path(conn, :create), monitor_event: @invalid_attrs
    assert html_response(conn, 200) =~ "New monitor event"
  end

  test "shows chosen resource", %{conn: conn} do
    monitor_event = Repo.insert! %MonitorEvent{}
    conn = get conn, monitor_event_path(conn, :show, monitor_event)
    assert html_response(conn, 200) =~ "Show monitor event"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, monitor_event_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    monitor_event = Repo.insert! %MonitorEvent{}
    conn = get conn, monitor_event_path(conn, :edit, monitor_event)
    assert html_response(conn, 200) =~ "Edit monitor event"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    monitor_event = Repo.insert! %MonitorEvent{}
    conn = put conn, monitor_event_path(conn, :update, monitor_event), monitor_event: @valid_attrs
    assert redirected_to(conn) == monitor_event_path(conn, :show, monitor_event)
    assert Repo.get_by(MonitorEvent, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    monitor_event = Repo.insert! %MonitorEvent{}
    conn = put conn, monitor_event_path(conn, :update, monitor_event), monitor_event: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit monitor event"
  end

  test "deletes chosen resource", %{conn: conn} do
    monitor_event = Repo.insert! %MonitorEvent{}
    conn = delete conn, monitor_event_path(conn, :delete, monitor_event)
    assert redirected_to(conn) == monitor_event_path(conn, :index)
    refute Repo.get(MonitorEvent, monitor_event.id)
  end
end
