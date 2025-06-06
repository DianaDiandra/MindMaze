# class PerformancesController < ApplicationController
#   before_action :authenticate_user!
#   before_action :set_target
#   before_action :set_performance, only: [:show]

#   helper PerformancesHelper

#   def index
#   @target = Target.find(params[:target_id])
#   @performances = @target.performances.includes(:game).order(created_at: :desc)
#   # @performances = @target.performances.includes(:game)
#   end



#   def new
#     @performance = @target.performances.new
#   end

#   def create
#     Rails.logger.info " RECEIVED PARAMS: #{params[:performance].inspect}"
#     @performance = @target.performances.new(performance_params)
#     @performance.completed = true
#     if @performance.save
#       redirect_to target_performances_path(@target), notice: "Performance recorded!"
#     else
#       render :new, status: :unprocessable_entity
#     end
#   end

#   def show
#   end

#   private

#   def set_target
#     @target = current_user.targets.find(params[:target_id])
#   end

#   def set_performance
#     @performance = @target.performances.find(params[:id])
#   end

#   def performance_params
#     params.require(:performance).permit(
#       :description,
#       :score,
#       :last_score,
#       :final_score,
#       :accuracy,
#       :completed,
#       :time,
#       :game_id
#     )
#   end
# end

class PerformancesController < ApplicationController
  before_action :authenticate_user!

  # Only load @target for actions that need it
  before_action :set_target, only: [:show, :new, :create]
  before_action :set_performance, only: [:show]

  def index
    performances = current_user.performances.includes(:game, :target).order(created_at: :desc)

    if params[:category].present?
      performances = performances.joins(:game).where(games: { category: params[:category] })
    end

    if params[:game_name].present?
      performances = performances.joins(:game).where(games: { name: params[:game_name] })
    end

    if params[:date].present?
      performances = performances.where("performances.created_at >= ?", params[:date])
    end

    @performances = performances

    # 👇 Add this to populate dropdown
    @game_names = current_user.performances.includes(:game).map(&:game).uniq(&:id).map(&:name).sort
  end


  def show
    # @performance already loaded with target scope
  end

  def new
    @performance = @target.performances.new
  end

  def create
    @performance = @target.performances.new(performance_params)
    @performance.completed = true
    if @performance.save
      redirect_to target_performance_path(@target, @performance), notice: "Performance recorded!"
    else
      render :new, status: :unprocessable_entity
    end
  end


  private

  def set_target
    @target = current_user.targets.find(params[:target_id])
  end

  def set_performance
    @performance = @target.performances.find(params[:id])
  end

  def performance_params
    params.require(:performance).permit(
      :description,
      :score,
      :last_score,
      :final_score,
      :accuracy,
      :completed,
      :time,
      :game_id
    )
  end
end
