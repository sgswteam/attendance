class AddColmnCourseTitleToCourse < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :title, :string
  end
end
