class CreateTwitterFriendsAndUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :slug
      t.string :twitter_handle
      t.integer :following_count
      t.timestamps
    end

    add_index :users, :slug, unique: true

    create_table :twitter_friends do |t|
      t.string :handle
      t.string :name
      t.boolean :verified
      t.string :profile_image_url
      t.timestamps
    end


    create_table :twitter_friends_users do |t|
      t.belongs_to :user, index: true
      t.belongs_to :twitter_friend, index: true
    end
  end
end
