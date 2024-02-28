# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, only: %i(edit update)

  def new; end

  def edit; end

  def create
    @user = User.find_by name: params[:name]
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "email.password_reset.subject"
      redirect_to root_path
    else
      flash.now[:danger] = t "email.not_found"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update user_params
      flash[:success] = t "update.user.success_message"
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def load_user
    @user = User.find_by reset_digest: params[:id]
    return if @user

    flash[:danger] = t "not_found.user"
    redirect_to root_url
  end

  def user_params
    params.permit :password, :password_confirmation
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "email.activation.deactivated"
  end
end
