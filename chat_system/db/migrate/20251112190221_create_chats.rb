class CreateChats < ActiveRecord::Migration[8.1]
  def change
    create_table :chats do |t|
      t.references :application, null: false, foreign_key: true
      t.integer :number, unsigned: true
      t.bigint :messages_count, unsigned: true, default: 0, null: true
      t.timestamps
    end

    # Composite unique index: ensures number is unique per application.
    add_index :chats, [:application_id, :number], unique: true
  end
end
