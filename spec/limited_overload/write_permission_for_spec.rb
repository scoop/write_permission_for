require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "write_permission_for" do
  before(:each) do
    @project = Project.make
    @user = User.make
    @creator = @project.user
    @admin = User.make(:admin)
  end

  describe ":creator => true" do
    before(:each) do
      Project.class_eval do
        write_permission_for :creator => true
      end
    end

    it "is writeable for creator" do
      @project.should be_writeable_for(@creator)
    end
    
    it "is not writeable for user" do
      @project.should_not be_writeable_for(@user)
    end
    
    it "is not writeable for admin" do
      @project.should_not be_writeable_for(@admin)
    end
  end

  describe ":admin" do
    before(:each) do
      Project.class_eval do
        write_permission_for :admin
      end
    end

    it "is not writeable for user" do
      @project.should_not be_writeable_for(@user)
    end
  
    it "is not writeable for creator" do
      @project.should_not be_writeable_for(@creator)
    end
  
    it "is writeable for admin" do
      @project.should be_writeable_for(@admin)
    end
  end
  
  describe ":admin, :creator => true" do
    before(:each) do
      Project.class_eval do
        write_permission_for :admin, :creator => true
      end
    end

    it "is not writeable for user" do
      @project.should_not be_writeable_for(@user)
    end
  
    it "is writeable for creator" do
      @project.should be_writeable_for(@creator)
    end
  
    it "is writeable for admin" do
      @project.should be_writeable_for(@admin)
    end
  end
  
  describe "(:admin) { |record, user| user == project.user }" do
    before(:each) do
      Release.class_eval do
        write_permission_for(:admin) { |record, user| user == record.project.user }
      end
      @release = Release.make
      @release_creator = @release.user
      @project_creator = @release.project.user
    end

    it "is writeable for the project creator" do
      @release.should be_writeable_for(@project_creator)
    end

    it "is not writeable for user" do
      @release.should_not be_writeable_for(@user)
    end
  
    it "is not writeable for release creator" do
      @release.should_not be_writeable_for(@release_creator)
    end
  
    it "is writeable for admin" do
      @release.should be_writeable_for(@admin)
    end
  end
  
  describe ":delegate => :project" do
    before(:each) do
      Release.class_eval do
        write_permission_for :delegate => :project
      end
      
      Project.class_eval do
        write_permission_for :creator => true
      end
      
      @release = Release.make
      @release_creator = @release.user
      @project = @release.project
      @project_creator = @release.project.user
    end
    
    it "is writeable for the project creator" do
      @release.should be_writeable_for(@project_creator)
    end

    it "is not writeable for user" do
      @release.should_not be_writeable_for(@user)
    end

    it "is not writeable for release creator" do
      @release.should_not be_writeable_for(@release_creator)
    end
  
    it "is not writeable for admin" do
      @release.should_not be_writeable_for(@admin)
    end
  end
  
  describe "options hash" do
    before(:each) do
      Project.class_eval do
        write_permission_for :admin do |record, user, options|
          user && options[:action] != :destroy
        end
      end

      @project = Project.make
      @user = User.make
    end

    it "should take an options hash with writeable_for and hand it down to the block for extra flexibility" do
      @project.should be_writeable_for(@user)
      @project.should_not be_writeable_for(@user, :action => :destroy)
    end
  end
end