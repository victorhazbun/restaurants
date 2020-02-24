class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.references :user, foreign_key: true
      t.jsonb :data, null: false, default: {}

      t.timestamps
    end
    add_index :transactions, :data, using: :gin
  end
end
