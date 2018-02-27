class Comment < ApplicationRecord
  belongs_to :upload
  validates :body, presence: true
end
