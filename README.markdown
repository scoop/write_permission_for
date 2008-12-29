WritePermissionFor
==================

I like my authorization checking in my models, not in my controllers. (Call me weird.)

Also, I don't need sophisticated roles and other magic to deal with my models. That way the `write_permission_for` macro was born.

Example
=======

Simple example:

    class Project < ActiveRecord::Base
      belongs_to :user
      # ..
      write_permission_for :creator => true
    end
    
    project = Project.first
    creator = Project.first.user
    user = User.last
    
    project.write_permission_for?(creator)
    # => true
    project.write_permission_for?(user)
    # => false
    
More advanced example:

    # add_column :users, :admin, :boolean, :default => false
    class User < ActiveRecord::Base
      def role?(role)
        admin?
      end
    end

    class Project < ActiveRecord::Base
      belongs_to :user
      # ..
      write_permission_for :admin, :creator => true
    end

    project = Project.first
    creator = Project.first.user
    admin = User.find_by_admin(true)
    user = User.last
    
    project.write_permission_for?(admin)
    # => true
    project.write_permission_for?(creator)
    # => true
    project.write_permission_for?(user)
    # => false
    

Even more advanced example:

    class Release < ActiveRecord::Base
      belongs_to :project
      # ..
      write_permission_for :admin do |record, user|
        record.project.user == user
      end
    end
    
    class Project < ActiveRecord::Base
      belongs_to :user
    end
    
    class User < ActiveRecord::Base
    end

    release = Release.first
    project_creator = release.project.user
    
    release.write_permission_for?(project_creator)
    # => true

Running the specs
=================

You need to have the [rspec][1] and [factory\_girl][2] gems installed (both of which you should be using anyway).

    [sudo] gem install rspec
    [sudo] gem install thoughtbot-factory_girl --source http://gems.github.com

After that (and presuming SQLite is available on your system) running the specs should be a matter of:

    rake
    
Sample output:

    write_permission_for :creator => true
    - is writeable for creator
    - is not writeable for user
    - is not writeable for admin

    write_permission_for :admin
    - is not writeable for user
    - is not writeable for creator
    - is writeable for admin

    write_permission_for :admin, :creator => true
    - is not writeable for user
    - is writeable for creator
    - is writeable for admin

    write_permission_for (:admin) { |record, user| user == project.user }
    - is writeable for the project creator
    - is not writeable for user
    - is not writeable for creator
    - is writeable for admin
  

[1]: http://github.com/dchelimsky/rspec/tree/master
[2]: http://github.com/thoughtbot/factory_girl/tree/master

Copyright (c) 2008 Patrick Lenz, released under the MIT license
