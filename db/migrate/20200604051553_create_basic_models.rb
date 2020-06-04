class CreateBasicModels < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.string :name

      t.timestamps
    end

    create_table :teams do |t|
      t.string :name

      t.timestamps
    end

    create_table :players do |t|
      t.string :name
      t.belongs_to :team, foreign_key: true

      t.timestamps
    end

    create_table :achievements do |t|
      t.string :name

      t.timestamps
    end

    create_table :matches_teams, id: false do |t|
      t.belongs_to :match
      t.belongs_to :team
    end

    create_table :players_achievements do |t|
      t.belongs_to :player
      t.belongs_to :achievement
      t.belongs_to :match
    end
  end
end
