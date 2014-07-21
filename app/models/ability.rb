class Ability
  include CanCan::Ability

  def initialize(current_account)
    can :create, Pair
    can :create, Like do |like|
      like.pair.account != current_account && !current_account.likes.include?(like)
    end
    can :update, Account do |account|
      account == current_account
    end
    can :delete, Pair do |pair|
      pair.account == current_account
    end
    can :delete, Like do |like|
      like.pair.account != current_account && current_account.likes.include?(like)
    end
  end
end
