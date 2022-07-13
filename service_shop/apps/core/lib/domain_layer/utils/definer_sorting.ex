defmodule Core.DomainLayer.Utils.DefinerSorting do
  @moduledoc false

  def define(sort) do
    if sort != nil do
      if sort == "ASC" || sort == "DESC" do
        true
      else
        false
      end
    else
      true
    end
  end
end
