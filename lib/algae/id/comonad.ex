import TypeClass

definst Witchcraft.Comonad, for: Algae.Id do
  def extract(%{id: inner}), do: inner
end
