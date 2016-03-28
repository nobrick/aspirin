defmodule Aspirin.StatusChannel do
  use Phoenix.Channel

  def join("status:all", _msg, socket) do
    {:ok, socket}
  end

  def join("status" <> _sub, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end
