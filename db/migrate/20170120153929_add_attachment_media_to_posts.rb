class AddAttachmentMediaToPosts < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.attachment :media
    end
  end

  def self.down
    remove_attachment :posts, :media
  end
end
