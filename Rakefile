begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    root_files = FileList["README"]
    s.name = "rails-schema-validations"
    s.version = '0.8'
    s.summary = "Automatically generate validations from the schema"
    s.description = "Automatically generate validations from the schema"
    s.email = "greg@gregweber.info"
    s.homepage = "http://github.com/gregwebs/rails-schema-validations"
    s.description = "Automatically generate validations from the schema"
    s.authors = ['Greg Weber']
    s.files = root_files + FileList["{app,config,lib}/**/*"]
    s.extra_rdoc_files = root_files
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: gem install jeweler"
end
