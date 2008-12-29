module LimitedOverload
  module WritePermissionFor

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # class Project < ActiveRecord::Base
      #   write_permission_for :admin, :creator => true
      # end
      #
      # project.writeable_for?(user) # => true/false
      def write_permission_for(*args)
        options = args.extract_options!
        role = args.first.is_a?(Symbol) ? args.shift : nil
        
        define_method :write_permission_for_creator? do |user|
          if options.delete(:creator)
            return unless user and not new_record? and respond_to?(:user)
            self.user == user
          else
            false
          end
        end
        
        if delegate_to = options.delete(:delegate)
          delegate :write_permission_for?, :to => delegate_to
        else
          define_method :write_permission_for? do |user|
            return unless user and not new_record?

            (role && user.respond_to?(:role?) && user.role?(role)) ||
            write_permission_for_creator?(user) ||
            (block_given? && yield(self, user))
          end
        end
        alias_method :writeable_for?, :write_permission_for?
      end
      
    end
    
  end
end