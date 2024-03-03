# frozen_string_literal: true

class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy
  
  def new
    @micropost = Micropost.new
  end

  def create
    @micropost = @current_user.microposts.build micropost_params
    @micropost.image.attach params.dig(:micropost, :image)
    if @micropost.save
      flash[:success] = t "create.microposts.success_message"
      redirect_to root_url
    else
      @pagy, @feed_items = pagy current_user.feed, items: Settings["PERPAGE_5"]
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "delete.micropost.success_message"
      redirect_to root_path
    else
      flash[:danger] = t "delete.micropost.fail_message"
      redirect_to request.referer || root_url
    end
  end

  private

  def micropost_params
    params.permit :content, :image
  end

  def correct_user
    @micropost = @current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "invalid_message"
    redirect_to request.referrer || root_url
  end
end
