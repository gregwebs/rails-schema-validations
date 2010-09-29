require File.join(File.dirname(__FILE__), 'test_helper')

def load_schema
  # sqlite doesn't support limits in the schema!
  ActiveRecord::Base.establish_connection(
    :adapter => "mysql",
    :database => "validations_from_schema"
  )

  ActiveRecord::Schema.define do
    create_table "models", :force => true do |t|
      %w(string integer float datetime date).each do |kind|
        t.send(kind, kind)
        t.send(kind, "#{kind}_notnull", :null => false)
      end
      %w(string integer).each do |kind|
        t.send(kind, "#{kind}_limit", :limit => 4)
        t.send(kind, "#{kind}_limit_notnull", :limit => 4, :null => false)
      end

      t.integer :indexed_id, :null => false
      t.integer :unique_id, :null => false
    end

    add_index 'models', ['indexed_id']
    add_index 'models', ['unique_id'], :unqiue => true
  end
end

load_schema

class Model < ActiveRecord::Base
  validations_from_schema
end

context Model do
  setup { Model.new }

  def asserts_error_on field, value 
    asserts("#{field} has an error with #{value.inspect}") do
      topic.send("#{field}=", value)
      topic.valid?
      topic.errors[field.to_sym].present?
    end
  end

  def asserts_no_error_on field, value 
    asserts("#{field} has no error with #{value.inspect}") do
      topic.send("#{field}=", value)
      topic.valid?
      topic.errors[field.to_sym].blank?
    end
  end

  # null
  %w(string integer float date datetime).each do |name|
    asserts_no_error_on name, nil
    asserts_error_on "#{name}_notnull", nil
  end
  %w(string integer).each do |name|
    asserts_no_error_on "#{name}_limit", nil
    asserts_error_on "#{name}_limit_notnull", nil
  end

  # only_integer
  asserts_error_on :integer_limit, 1.1

  asserts_error_on :string_limit, '12345678910'
  asserts_error_on :integer_limit, 2 ** (8 * 4)

  asserts_no_error_on :string_limit, '12'
  asserts_no_error_on :integer_limit, 2 ** (8 * 3)

  asserts_error_on :indexed_id, nil
  asserts_error_on :unique_id, nil
end
