# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    return @user if @user

    flash[:errors] = t("not_found.user")
    redirect_to root_path
  end

  def new; end

  def create
    @user = User.create(user_params)
    handle_user_save_result(@user)
  end

  private

  def handle_user_save_result(user)
    if user.save
      flash[:success] = t("create.user.success_message", name: t("create.user.label_name"))
      redirect_to user
    else
      flash[:errors] = user.errors.full_messages
      flash[:errors_count] = user.errors.count
      redirect_to sign_up_path
    end
  end

  def user_params
    params.permit(:name, :birthday, :password, :password_confirmation)
  end
end
