class CreateApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :applications do |t|
      t.string :name
      t.string :token
      t.bigint :chats_count, unsigned: true, default: 0, null: true
      t.timestamps
    end
  end
end
