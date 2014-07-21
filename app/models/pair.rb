# coding: utf-8
class Pair
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  field :_id, :type => String
  field :a, :type => String
  field :b, :type => String
  validates_length_of :a, :maximum => 1000
  validates_length_of :b, :maximum => 1000
  validates :a, :presence => {:message => '両方とも必須です。'}
  validates :b, :presence => {:message => '両方とも必須です。'}
  validate do |pair|
    if pair.a == pair.b
      pair.errors.add(:base, :must_be_different)
    elsif Pair.where(a: pair.a, b: pair.b).first || Pair.where(a: pair.b, b: pair.a).first
      pair.errors.add(:base, :must_be_unique)
    end
  end
  has_many :likes
  belongs_to :account, foreign_key: :account_id
  paginates_per 5
end
