defmodule Aspirin.MonitorEventView do
  use Aspirin.Web, :view

  def monitor_event_identity_class(event) do
    String.replace("#{event.type}-#{event.addr}-#{event.port}", ".", "_")
  end
end
