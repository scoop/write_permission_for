dir = File.dirname(__FILE__)
$LOAD_PATH.unshift "#{dir}/../lib"

require 'rubygems'
require 'spec'
require 'machinist'
require 'limited_overload/write_permission_for'
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

    User.blueprint do
      login 'John'
      admin false
    end

    User.blueprint(:admin) do
      login 'Admin'
      admin true
    end

    Project.blueprint do
      name 'Linux'
      user
    end
    
    Release.blueprint do
      version "2.6.20"
      project
      user
    end
  end
end