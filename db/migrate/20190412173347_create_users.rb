class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :hashed_password
      t.string :salt
      t.boolean :is_god_admin
      t.boolean :is_admin
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
