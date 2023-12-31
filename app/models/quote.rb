class Quote < ApplicationRecord
    validates :name, presence: true

    belongs_to :company

    scope :ordered, -> { order(id: :desc) }

    broadcasts_to ->(quote) { [quote.company, "quotes"] }, inserts_by: :prepend

    after_create_commit -> { broadcast_prepend_to "quotes" }
    after_update_commit -> { broadcast_replace_to "quotes" }
    after_destroy_commit -> { broadcast_remove_to "quotes" }
end
