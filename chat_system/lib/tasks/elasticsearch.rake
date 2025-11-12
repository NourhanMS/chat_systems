namespace :elasticsearch do
  desc "Recreate and import Message index if not exists"
  task reindex_messages: :environment do
    unless Message.__elasticsearch__.index_exists?
      Message.__elasticsearch__.create_index!
      Message.import
      puts "Index created and messages imported."
    else
      puts "Index already exists, skipping creation."
    end
  end
end
