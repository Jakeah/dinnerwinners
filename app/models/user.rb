# == Schema Information
#
# Table name: users
#
#  id                                   :integer          not null, primary key
#  first_name                           :string(255)
#  last_name                            :string(255)
#  email                                :string(255)
#  phone                                :string(255)
#  hashed_password                      :string(255)
#  is_god_admin                         :boolean
#  is_admin                             :boolean
#  deleted_at                           :datetime
#  created_at                           :datetime
#  updated_at                           :datetime
#
require 'password_utilities'
class User < ApplicationRecord
  include PasswordUtilities
  include StringFilter

  before_validation :strip_input_fields # concerns/string_filter

  def self.active_users
    where(deleted_at: nil)
  end

  def full_name
    unless first_name.blank? && last_name.blank?
      "#{User.firstcap(first_name)} #{User.firstcap(last_name)}"
    else
      email
    end
  end

  def User.firstcap my_string
    if my_string.blank?
      ''
    elsif my_string.size == 1
      my_string[0..0].capitalize
    else
      my_string[0..0].capitalize + my_string[1..-1]
    end
    #my_string.gsub(/^(\w)/) { $1.chars.capitalize }  # /^([a-z])/
  end


end
