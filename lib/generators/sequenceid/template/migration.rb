class AddSequenceNumTo<%= @nested_resource.to_s.underscore.pluralize.camelize %> < ActiveRecord::Migration
  <% @parent_resource_name = @parent_resource.to_s.downcase %>
  <% @nested_resource_name = @nested_resource.to_s.underscore.pluralize %>
  def self.up
    add_column :<%= @nested_resource_name %>, :sequence_num, :integer, null: false
    update_sequence_num_values
    add_index :<%= @nested_resource_name %>, [:sequence_num,:<%= @parent_resource_name %>_id], unique: true
  end

  def self.down
    remove_index  :<%= @nested_resource_name %>, column: [:sequence_num, :<%= @parent_resource_name %>_id]
    remove_column :<%= @nested_resource_name %>, :sequence_num
  end

  def self.update_sequence_num_values
    <%= @parent_resource.to_s %>.all.each do |parent|
      cntr = 1
      parent.<%= @nested_resource_name %>.reorder("id").all.each do |nested|
        nested.sequence_num = cntr
        cntr += 1
        nested.save
      end
    end
  end
end

