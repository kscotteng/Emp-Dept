require 'active_record'

ActiveRecord::Base.establish_connection(
	 adapter: 'sqlite3',
	 database: 'development.sqlite3'
)

class EmployeeMigration < ActiveRecord::Migration
	def change
		create_table :employees do |t|
			t.references :department
      t.string :name
      t.decimal :salary, precision: 8, scale: 2
      t.string :phone
      t.string :email
      t.text :review
      t.boolean :satisfactory, default: true
      t.timestamps null: false
		end

    create_table :departments do |t|
      t.string :name
      t.timestamps null: false
    end

  end
end
