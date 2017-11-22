module StringExtensions
  def titlecase
    self.split.map(&:capitalize).join(" ")
  end
end

String.class_eval { include StringExtensions }
