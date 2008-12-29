dir = File.dirname(__FILE__)
$LOAD_PATH.unshift "#{dir}/../lib"

require 'rubygems'
require 'spec'
require 'factory_girl'
require 'write_permission_for'
require File.join(dir, '../config/environment')

Spec::Runner.configure do |config|
  config.mock_with :rr
  
  config.before :suite do
    
    load File.join(dir, "../db/schema.rb")

    User = Class.new(ActiveRecord::Base)
    Project = Class.new(ActiveRecord::Base)
    Release = Class.new(ActiveRecord::Base)
    
    User.class_eval do
      def role?(role)
        admin?
      end
    end

    ActiveRecord::Base.send :include, LimitedOverload::WritePermissionFor

    Project.class_eval do
      belongs_to :user
    end

    Release.class_eval do
      belongs_to :project
      belongs_to :user
    end

    Factory.define :user do |u|
      u.login 'John'
      u.admin false
    end

    Factory.define :admin, :class => User do |u|
      u.login 'Admin'
      u.admin true
    end

    Factory.define :creator, :class => User do |u|
      u.login 'Creator'
      u.admin false
    end

    Factory.define :project do |p|
      p.name 'Linux'
      p.association :user, :factory => :creator
    end
    
    Factory.define :release do |r|
      r.version "2.6.20"
      r.association :project, :factory => :project
      r.association :user, :factory => :creator
    end

  end
end