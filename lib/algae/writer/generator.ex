alias TypeClass.Property.Generator

defimpl TypeClass.Property.Generator, for: Algae.Writer do
  def generate(_), do: Algae.Writer.new({Generator.generate(0), Generator.generate("")})
end
