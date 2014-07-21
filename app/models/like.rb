class Like
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  field :_id, :type => String
  belongs_to :account
  belongs_to :pair
end
