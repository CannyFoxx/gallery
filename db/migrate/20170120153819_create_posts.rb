class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts, id: :uuid do |t|
      t.boolean :hidden, default: false
      t.boolean :gps, default: false
      t.float :latitude
      t.float :longitude
      t.string :address

      t.timestamps
    end
  end
end
