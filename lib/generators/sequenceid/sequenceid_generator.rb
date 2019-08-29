require 'rails/generators/active_record'

class SequenceidGenerator < ActiveRecord::Generators::Base
  #Rails::Generators::NamedBase
  desc "This generator is for sequenceid, which creates sequential id's in the URL for nested resources. Especially useful for SaaS based apps where the unique resource is likely a nested resource of company\n Usage: rails generate sequenceid <parent resource> <nested resource>"
  ORM=ActiveRecord::Base #TODO: Make this generic for other ORM's
  source_root File.expand_path("../template",__FILE__)

  def initialize_sequenceid
    parent_resource_s=@_initializer[0][0]
    nested_resource_s=@_initializer[0][1]
    if (!parent_resource_s || !nested_resource_s)
      puts "Usage: rails generate sequenceid <parent resource> <nested resource> "
      puts "eg, rails generate company user"
      puts "the nested resource must be in someway nested to the parent resource to avoid a conflict in url's"
      puts "eg, if a company is represented by subdomain of the url, you will always have a unique url for the user even though the sequence id's might be shared"
      puts "so if two company's exist, 7vals and sevenvals, then their first users will have urls: http://7vals.easyofficeinventory.com/users/1 and http://sevenvals.easyofficeinventory.com/users/1"
      puts "note how the users/1 is now used to get the sequence number and NOT the unique id of the user"
      exit
    end
    begin
      @parent_resource=eval parent_resource_s.classify
      @nested_resource=eval nested_resource_s.classify
      if((!@parent_resource.ancestors.include?ORM) || (!@nested_resource.ancestors.include?ORM))
        puts "ERROR: both #{parent_resource_s} and #{nested_resource_s} need to be ActiveRecords"
        exit
      end

      if((!@nested_resource.new.respond_to? parent_resource_s) & (!@nested_resource.new.respond_to? parent_resource_s.pluralize))
        puts "ERROR: #{nested_resource_s} should have an association with #{parent_resource_s} otherwise its not possible to have a unique sequence number to identify #{nested_resource_s} from the url"
        #TODO need to check for belongs_to relation
        exit
      end
      #if not belongs to
      if(!@parent_resource.new.respond_to? @nested_resource.to_s.downcase.pluralize)
        exit unless yes?("ERROR: The resource #{nested_resource_s} should have a belongs to association with #{parent_resource_s}, do you still want to continue (risky)?")
      end

    rescue =>e
      puts "ERROR: both #{parent_resource_s} and #{nested_resource_s} need to be ActiveRecords.\n #{e.message}"
      exit
    end
  end

  def do_work
    #create migration and run migrate script
    migration_template "migration.rb", "db/migrate/add_sequence_num_to_#{@nested_resource.to_s.downcase.pluralize}.rb"
    #inject into model class module includeA
    @model_path ||= File.join("app", "models", "#{@nested_resource.to_s.underscore}.rb")
    inject_into_class(@model_path,@nested_resource,"\tsequenceid :#{@parent_resource.to_s.downcase.to_sym} , :#{@nested_resource.to_s.downcase.pluralize.to_sym}\n")
  end
end
