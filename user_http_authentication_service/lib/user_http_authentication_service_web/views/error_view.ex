defmodule UserHttpAuthenticationServiceWeb.ErrorView do
  use UserHttpAuthenticationServiceWeb, :view

  def render("404.json", _assigns) do
    %{message: "Not Found"}
  end

  def render("500.json", _assigns) do
    %{message: "Server Error"}
  end
end
