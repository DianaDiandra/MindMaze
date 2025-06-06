class PerformancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_target
  before_action :set_performance, only: [:show]

  helper PerformancesHelper

  def index
  @target = Target.find(params[:target_id])
  @performances = @target.performances.includes(:game).order(created_at: :desc)
  # @performances = @target.performances.includes(:game)
  end



  def new
    @performance = @target.performances.new
  end

  def create
    @performance = @target.performances.new(performance_params)
    @performance.completed = true

    if @performance.save
      redirect_to target_performances_path(@target), notice: "Performance recorded!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def set_target
    @target = current_user.targets.find(params[:target_id])
  end

  def set_performance
    @performance = @target.performances.find(params[:id])
  end

  def performance_params
    params.require(:performance).permit(:description, :accuracy, :score, :last_score, :time, :completed, :game_id)
  end
end
