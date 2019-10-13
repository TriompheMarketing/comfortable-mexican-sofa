class CreateWhitelists < ActiveRecord::Migration[5.2]

  def change
    create_table :whitelists do |t|
      t.string :ip_address
      t.timestamps
    end
  end

end