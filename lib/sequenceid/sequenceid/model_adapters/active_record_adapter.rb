require 'sequenceid/model_adapters/sequenceid_logic'
ActiveRecord::Base.class_eval do
  extend Sequenceid::Logic
end

