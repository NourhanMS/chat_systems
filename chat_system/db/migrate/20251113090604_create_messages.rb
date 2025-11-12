class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.integer :number, unsigned: true
      t.string :body
      t.timestamps
    end

    # Composite unique index: ensures number is unique per chat.
    add_index :messages, [:chat_id, :number], unique: true
  end
end
