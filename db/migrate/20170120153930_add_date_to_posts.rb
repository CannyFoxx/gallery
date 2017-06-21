class AddDateToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :date, 'timestamp with time zone'
  end
end
