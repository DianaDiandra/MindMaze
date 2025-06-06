class AddFinalScoreAndLastScoreToPerformances < ActiveRecord::Migration[7.2]
  def change
    add_column :performances, :final_score, :integer
    add_column :performances, :last_score, :integer
  end
end
