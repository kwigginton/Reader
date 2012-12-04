# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121123011157) do

  create_table "categories", :force => true do |t|
    t.string   "category_name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "categories_feeds", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "feed_id"
  end

  create_table "categories_posts", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "post_id"
  end

  create_table "feeds", :force => true do |t|
    t.string   "feed_url"
    t.string   "title"
    t.string   "author"
    t.binary   "feed_data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "feed_id"
    t.binary   "summary"
    t.binary   "content"
    t.string   "author"
    t.float    "rank"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "feed_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "password_digest"
    t.string   "role"
    t.string   "email"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "votes", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "votable_id"
    t.string   "votable_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end
