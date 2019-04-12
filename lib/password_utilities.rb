module PasswordUtilities

  def self.included(base)
    base.extend(ClassMethods)
  end

  # password is a virtual attribute
  def password
    @password
  end

  # method=  overrides normal accessor method, see ruby cookbook 8.6
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    self.create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end


  module ClassMethods
    def authenticate(email, password)
      if email.nil? || password.nil?
        return nil
      end
      #puts "in user model auth looking for email " + email + " and pw " + password
      # note that both User and RegistrationUser use this method
      user = self.active_users.order(:created_at).where(email: email).first
      if user
        if user.salt.blank?
          user.create_new_salt
          user.save
        end
        expected_password = encrypted_password(password, user.salt)
        #puts "in user model auth expected_password = " + expected_password
        #puts "in user model auth hashed_password = " + user.hashed_password
        if user.hashed_password != expected_password || !user.deleted_at.blank?
          user = nil
        end
      end
      user
    end

    def encrypted_password(password, salt)
      # errors here are caused when imported user does not have a password or salt set (like physio ones)
      # TODO  should generate nicer error
      string_to_hash = password + "wibble" + salt
      Digest::SHA1.hexdigest(string_to_hash)
    end

  end

  class PasswordGeneration

    def self.generate_random_string(size = 8)
      #    chars(('a'..'z').to_a + ('0'..'9').to_a) - %w(i o 0 1 1 0)
      #    (1..size).collect{ |a| chars[rand(chars.size)]}.join
      chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789'
      password = ''
      size.times {password << chars[rand(chars.size)]}
      password
    end
  end
end