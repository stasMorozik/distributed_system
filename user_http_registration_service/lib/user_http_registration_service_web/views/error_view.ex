defmodule UserHttpRegistrationServiceWeb.ErrorView do
  use UserHttpRegistrationServiceWeb, :view

  def render("404.json", _assigns) do
    %{message: "Not Found"}
  end

  def render("500.json", _assigns) do
    %{message: "Server Error"}
  end
end
