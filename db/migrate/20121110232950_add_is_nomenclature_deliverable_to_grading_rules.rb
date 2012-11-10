class AddIsNomenclatureDeliverableToGradingRules < ActiveRecord::Migration
  def self.up
    add_column :grading_rules, :is_nomenclature_deliverable, :boolean
  end

  def self.down
    remove_column :grading_rules, :is_nomenclature_deliverable
  end
end
