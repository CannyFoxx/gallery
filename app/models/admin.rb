class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :timeoutable and :omniauthable, :registerable, :recoverable, :rememberable,
  devise :database_authenticatable, :trackable, :validatable, :lockable
end
