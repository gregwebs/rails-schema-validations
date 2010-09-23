# this will put it in the scope of a model
module ActiveRecord::Validations::ClassMethods
  def validations_from_schema
    self.content_columns.map do |col|
      case col.type
      when :integer
        validates_numericality_of col.name, :only_integer => true, :allow_nil => col.null
      when :float
        validates_numericality_of col.name, :allow_nil => col.null
      #when :time, :datetime :string 
      end
    end.compact + content_columns.map do |col|
      validates_presence_of col.name unless col.null
    end.compact + content_columns.map do |col|
      if col.limit
        validates_length_of col.name, :maximum => col.limit, :allow_nil => col.null
      end
    end
  end
end
