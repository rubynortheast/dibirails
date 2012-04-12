class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :body
      t.string :user_name
      t.references :question
      t.timestamps
    end
  end
end
