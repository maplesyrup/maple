class StatsController < ApplicationController

  def index
    # Retrieve last and this weeks' stats
    this_week = important_models(Date.today)
    last_week = important_models(1.week.ago.utc)

    stats = {
      :last_week => last_week,
      :this_week => this_week,
      :increase => {
        :ads => percent_difference(last_week[:ads], this_week[:ads]),
        :users => percent_difference(last_week[:users], this_week[:users]),
        :companies => percent_difference(last_week[:companies], this_week[:companies]),
        :campaign => percent_difference(last_week[:campaign], this_week[:campaign])
      }
    }

    render :json => stats

  end

  def important_models(end_date)
    # Retrieve number of models from
    # beginning of time until end_date
    data = {
      :ads => Post.where("created_at <= (?)", end_date).length,
      :users => User.where("created_at <= (?)", end_date).length,
      :companies => Company.where("created_at <= (?)", end_date).length,
      :campaign => Campaign.where("created_at <= (?)", end_date).length
    }
    return data
  end

end