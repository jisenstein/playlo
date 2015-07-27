class RenameTypeColumnInTracksTable < ActiveRecord::Migration
  def change
    remove_column :tracks, :type
  end
end
