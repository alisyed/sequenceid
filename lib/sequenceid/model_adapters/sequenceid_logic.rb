module Sequenceid
  module Logic

    def sequenceid(parent_rel,current_rel)
      #TODO:need to ensure multiple before_saves are not added - possibly use respond_to?
      class_eval do
        before_create :set_sequence_num
        after_rollback :reset_sequence_num
        include InstanceMethods
      end
      @relation_for_sequence_string=(parent_rel+"."+current_rel)
    end

    module InstanceMethods
      def to_param
        "#{sequence_num}"
      end

      protected
      def set_sequence_num
        if new_record?
	  @relation_sequence=self.send @relation_for_sequence_string
          self.sequence_num=@relation_sequence.order("id").last.try(:sequence_num) || 0
          self.sequence_num+=1
        end
        return true
      end

      def reset_sequence_num
        @save_counter||=1
        if new_record? && @save_counter<3
          logger.info "SQUENCENUM:: attempt number #{@save_counter} of a max 2"
          self.sequence_num=@relation_sequence.order("id").last.try(:sequence_num) +1
          @save_counter+=1
          save
        else
          raise
        end
      end
    end
  end
end
