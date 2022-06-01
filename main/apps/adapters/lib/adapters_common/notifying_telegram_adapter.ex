defmodule Adapters.AdaptersCommon.NotifyingTelegramAdapter do
  alias Core.CoreDomains.Common.Ports.Notifying

  @behaviour Notifying

  @spec notify(binary, binary) :: any()
  def notify(address, message) do
    IO.inspect("For #{address}")
    IO.inspect("#{message}")
  end
end
