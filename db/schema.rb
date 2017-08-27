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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 0) do

  create_table "documents", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "name"
    t.text "description"
    t.boolean "public", default: false
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.integer "document_id"
    t.text "topic"
    t.text "color"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "tagged_by_model", default: false
    t.index ["document_id"], name: "index_tags_on_document_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "name"
    t.text "email"
    t.text "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "privilege"
  end

end
