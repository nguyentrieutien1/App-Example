# frozen_string_literal: true

class UsersController < ApplicationController
  def index; end

  def show
    @user = User.find_by(id: params[:id])
    render json: @user
  end

  def create
    @user = User.create(user_params)
    if @user.save
      flash[:success] = t("create.success_message", name: t("create.label_name"))
    else
      flash[:errors] = @user.errors.full_messages
    end
    redirect_to create_user_path
  end

  private

  def user_params
    params.permit(:name, :birthday, :password)
  end
end
