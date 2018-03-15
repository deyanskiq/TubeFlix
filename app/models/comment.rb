class Comment < ApplicationRecord
  belongs_to :upload
  validates :body, presence: true,  length: {maximum: 100}
end
