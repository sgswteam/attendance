class RemoveImageFromStudents < ActiveRecord::Migration[5.1]
  def change
    remove_column :students, :image, :string
  end
end
