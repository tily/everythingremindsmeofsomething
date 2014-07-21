class Account
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  field :_id, :type => String
  field :name, :type => String
  field :screen_name, :type => String
  field :role, :type => String
  field :uid, :type => String
  field :provider, :type => String
  has_many :pairs
  has_many :likes
  validates_length_of :name, :minimum => 1, :maximum => 1000, :on => :update

  def self.create_with_omniauth(auth)
    create! do |account|
      account.provider = auth["provider"]
      account.uid = auth["uid"]
      account.screen_name = auth["info"]["nickname"]
      account.role = "users"
      account.name = ::Faker::Japanese::Name.name
    end
  end

  def self.find_by_id(id)
      find(id) rescue nil
  end
end
