class User < ApplicationRecord
    extend Devise::Models
            # Include default devise modules.
            devise :database_authenticatable, :registerable,
                    :recoverable, :rememberable, :validatable
                    
            include DeviseTokenAuth::Concerns::User
    
    has_many :todo_lists, dependent: :destroy
    validates :email, presence: true
end
