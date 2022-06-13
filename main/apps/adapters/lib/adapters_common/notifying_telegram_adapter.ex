defmodule Adapters.AdaptersCommon.NotifyingTelegramAdapter do
  alias Core.CoreDomains.Common.Ports.Notifying

  @behaviour Notifying

  @spec notify(binary, binary, binary) :: any()
  def notify(address, subject, message) do
    IO.inspect("For #{address}")
    IO.inspect("Subject - #{subject}")
    IO.inspect("#{message}")
  end
end
