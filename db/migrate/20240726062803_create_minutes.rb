class CreateMinutes < ActiveRecord::Migration[7.1]
  def change
    create_table :minutes do |t|
      t.text :content
      t.date :meeting_date

      t.timestamps
    end
  end
end
