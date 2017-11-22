class Account
  def initialize(institution, name, type)
    @institution = institution
    @name = name
    @type = type
  end

  def to_s
    "#{@name} (#{@institution} #{@type})"
  end
end
