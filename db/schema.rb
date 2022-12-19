# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_221_219_123_500) do
  create_table 'followability_relationships', force: :cascade do |t|
    t.string 'followerable_type', null: false
    t.integer 'followerable_id', null: false
    t.string 'followable_type', null: false
    t.integer 'followable_id', null: false
    t.integer 'status'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[followable_type followable_id], name: 'index_followability_relationships_on_followable'
    t.index %w[followerable_type followerable_id], name: 'index_followability_relationships_on_followerable'
  end

  create_table 'messages', force: :cascade do |t|
    t.integer 'user_id', null: false
    t.integer 'room_id', null: false
    t.text 'body'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['room_id'], name: 'index_messages_on_room_id'
    t.index ['user_id'], name: 'index_messages_on_user_id'
  end

  create_table 'participants', force: :cascade do |t|
    t.integer 'user_id', null: false
    t.integer 'room_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['room_id'], name: 'index_participants_on_room_id'
    t.index ['user_id'], name: 'index_participants_on_user_id'
  end

  create_table 'rooms', force: :cascade do |t|
    t.string 'name'
    t.boolean 'is_private', default: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: ''
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.decimal 'latitude', precision: 10, scale: 6
    t.decimal 'longitude', precision: 10, scale: 6
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'full_name', null: false
    t.string 'uid'
    t.string 'avatar_url'
    t.string 'provider'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'messages', 'rooms'
  add_foreign_key 'messages', 'users'
  add_foreign_key 'participants', 'rooms'
  add_foreign_key 'participants', 'users'
end
