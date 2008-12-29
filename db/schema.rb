ActiveRecord::Schema.define(:version => 3) do
  create_table "users", :force => true do |t|
    t.string "login"
    t.boolean "admin"
  end

  create_table "projects", :force => true do |t|
    t.string "name"
    t.integer "user_id"
  end
  
  create_table "releases", :force => true do |t|
    t.string "version"
    t.integer "user_id"
    t.integer "project_id"
  end
end
