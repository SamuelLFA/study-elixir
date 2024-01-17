defmodule Recursive do
  def sum(list) do
    sum_rec(list, 0)
  end

  defp sum_rec([], acc) do acc end
  defp sum_rec([head | tail], acc) do
    sum_rec(tail, acc + head)
  end
end
