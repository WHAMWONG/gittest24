class Folder < ApplicationRecord
  has_many :to_do_items, dependent: :destroy

  belongs_to :user

  # validations

  # end for validations

  class << self
  end
end
