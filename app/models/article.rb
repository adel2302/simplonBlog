class Article < ActiveRecord::Base
  acts_as_votable
  acts_as_taggable
  has_attached_file :image, styles: { large: "900x300", medium: "330x300>", thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  has_many :comments
  belongs_to :user
end
