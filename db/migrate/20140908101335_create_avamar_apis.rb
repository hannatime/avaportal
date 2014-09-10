class CreateAvamarApis < ActiveRecord::Migration
  def change
    create_table :avamar_apis do |t|

      t.timestamps
    end
  end
end
