# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :transactions, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  def to_token_payload
    {
      sub: id,
      email: email
    }
  end

  def as_json(options)
    super(only: [:id, :email])
  end
end
