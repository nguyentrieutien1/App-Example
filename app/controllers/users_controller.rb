# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    return @user if @user

    flash[:error] = t("not_found.user")
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create user_params
    if @user.save
      flash[:success] = t("create.user.success_message", name: t("create.user.label_name"))
      redirect_to @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :birthday, :password, :password_confirmation)
  end
end
