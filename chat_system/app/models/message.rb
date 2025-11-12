class Message < ApplicationRecord
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    validates :body, presence: true
    belongs_to :chat

    # Apply the English analyzer (stemming, stop words, lowercasing ..)
    # and only index the body for search.
    settings do
        mappings dynamic: false do
            indexes :body, type: :text, analyzer: :english
        end
    end
end
