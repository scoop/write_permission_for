2009-03-06
==========

You can now pass an optional hash to `writeable_for?` that is handed
down to the block in your model for extra flexibility in edge cases.

Example:

    class Project < ActiveRecord::Base
      # ..
      write_permission_for :admin do |record, user, options|
        user && options[:action] != :destroy
      end
    end

This would grant write permission to a user only if the action
argument passed in is not `:destroy`. An admin, since evaulated
outside of the block, will always be blessed with write
permission.

    project.writeable_for?(user)
    # => true

    project.writeable_for?(user, :action => :destroy)
    # => false

    project.writeable_for?(admin, :action => :destroy)
    # => true