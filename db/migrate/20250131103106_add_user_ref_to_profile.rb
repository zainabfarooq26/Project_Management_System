class AddUserRefToProfile < ActiveRecord::Migration[7.2]
  def change
    add_reference :profiles, :user
  end
end
