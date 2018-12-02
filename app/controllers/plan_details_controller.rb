class PlanDetailsController < ApplicationController
  def show
  end

  def create
    @plan_detail = @plan.plan_details.build(plan_detail_params)
    respond_to do |format|
      format.html { redirect_to @plan_detail }
      format.js
    end
  end

  def update
  end

  def destroy
  end

  private
    def plan_detail_params
      params.require(:plan_detail).permit(:date, :place, :action_type, :action, :action_memo)
    end
end
