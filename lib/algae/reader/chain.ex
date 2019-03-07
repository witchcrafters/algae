import TypeClass

definst Witchcraft.Chain, for: Algae.Reader do
  @force_type_instance true
  alias  Algae.Reader

  def chain(reader, link) do
    Reader.new(fn e ->
      reader
      |> Reader.run(e)
      |> link.()
      |> Reader.run(e)
    end)
  end
end
