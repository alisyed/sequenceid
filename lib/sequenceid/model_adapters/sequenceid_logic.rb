module Sequenceid
  module Logic

    def sequenceid(parent_rel_sym, current_rel_sym)
      @parent_rel  = parent_rel_sym.to_s
      @current_rel = current_rel_sym.to_s

      class_eval do
        before_create  :set_sequence_num
        after_rollback :reset_sequence_num
        include InstanceMethods
      end
    end

    module InstanceMethods
      def to_param
        "#{sequence_num}"
      end

      protected

      def set_sequence_num
        if new_record?
          self.sequence_num  = relation_sequence.reorder("id").last.try(:sequence_num) || 0  # REORDER to override order clause if default scope applied on nested_resource
          self.sequence_num += 1
        end
        return true
      end

      def reset_sequence_num
        @save_counter ||= 1
        if new_record? && valid?
          if @save_counter < 3
            logger.info "SEQUENCE_ID_GEM:: attempt number #{@save_counter} of a max 2"
            self.sequence_num=relation_sequence.order("id").last.try(:sequence_num) + 1
            @save_counter += 1
            save
          else
            raise
          end
        end
      end

      def relation_sequence
        resource_klass = get_sti_parent_class self.class
        self.send(resource_klass.instance_variable_get("@parent_rel")).send(resource_klass.instance_variable_get("@current_rel"))
      end

      #for Single Table Inheritance, we need to keep going up the hierarchy until we reach the class right below ActiveRecord. Probably
      #ought to fix this for extreme cases where models are based on a different hierarchy (monkey patch with your base model class)
      def get_sti_parent_class(klass)
        return klass if (klass.superclass == ActiveRecord::Base || klass.superclass == Object || klass.superclass.nil?)
        get_sti_parent_class(klass.superclass)
      end

    end
  end
end
