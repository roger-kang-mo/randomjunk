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

ActiveRecord::Schema.define(:version => 20130812001108) do

  create_table "comments", :force => true do |t|
    t.text     "author"
    t.text     "content"
    t.datetime "created_at"
    t.integer  "thought_id"
    t.string   "passcode"
  end

  create_table "minesweeper_records", :force => true do |t|
    t.string  "time"
    t.string  "name"
    t.integer "width"
    t.integer "height"
    t.integer "mines"
  end

  create_table "notes", :force => true do |t|
    t.text     "content"
    t.string   "author"
    t.datetime "created_at"
    t.integer  "x"
    t.integer  "y"
    t.integer  "size"
    t.integer  "z"
  end

  create_table "thoughts", :force => true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.integer  "thumbs"
    t.boolean  "approved"
  end

end
