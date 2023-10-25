class Task < ApplicationRecord
    belongs_to :category, optional: true

    validates :priority, inclusion: { in: ['Low', 'Medium', 'High'], message: "Priority must be either Low, Medium, or High" }


end
