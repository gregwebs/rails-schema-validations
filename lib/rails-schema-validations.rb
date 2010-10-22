# this will put it in the scope of a model
module ActiveRecord::Validations::ClassMethods
  def validations_from_schema
    self.columns.map do |col|
      next if col.primary

      case col.type
      when :integer
        # assuming unsigned!
        validates_numericality_of col.name, :only_integer => true, :allow_nil => col.null,
          :less_than => (2 ** (8 * col.limit)) / 2
      when :float
        # less_than would need to look at col.scale, col.float
        validates_numericality_of col.name, :allow_nil => col.null
      #when :time, :datetime
      when :string 
        if col.limit
          validates_length_of col.name, :maximum => col.limit, :allow_nil => col.null
        end
      when :boolean
        validates_inclusion_of col.name, :in => [true, false]
      end
    end.compact + content_columns.map do |col|
      validates_presence_of col.name unless col.null || col.type == :boolean
    end
  end
end
