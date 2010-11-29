# this will put it in the scope of a model
module ActiveRecord::Validations::ClassMethods
  def validations_from_schema options = {}
    except = [*options.delete(:except)].map {|c| c.to_s}
    fail "unexpected arguments" if options.size != 0

    self.columns.map do |col|
      next if col.primary or except.include? col.name

      case col.type
      when :integer
        # assuming unsigned!
        validates_numericality_of col.name, :only_integer => true, :allow_nil => col.null,
          :less_than => (2 ** (8 * col.limit)) / 2
      when :float
        # less_than would need to look at col.scale, col.float
        validates_numericality_of col.name, :allow_nil => col.null
      #when :time, :datetime
      when :string, :text
        if col.limit.to_i > 0 # Mysql enum type shows up as a string with a limit of 0
          validates_length_of col.name, :maximum => col.limit, :allow_nil => col.null
        end
      when :boolean
        validates_inclusion_of col.name, :in => [true, false], :allow_nil => col.null
      end
    end.compact + content_columns.map do |col|
      next if col.null or col.type == :boolean or except.include? col.name
      validates_presence_of col.name
    end
  end
end
