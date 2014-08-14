class CreatePosts < ActiveRecord::Migration
  def up
    create_table "posts", force: true do |t|
      t.string   "title"
      t.text     "body"
      t.string   "slug"
      t.datetime "active_at"
      t.datetime "inactive_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "main_image"
      t.integer  "user_id"
      t.boolean  "is_featured",           default: false
    end
  end
  def down
    remove_table :posts
  end
end
