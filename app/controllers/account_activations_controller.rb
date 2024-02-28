# frozen_string_literal: true

class AccountActivationsController < ApplicationController
  before_action :load_user, :check_activation, only: :edit

  def edit
    if @user.active
      log_in @user
      flash[:success] = t "email.activation.activated"
      redirect_to @user
    else
      flash[:danger] = t "server.error_message"
      redirect_to root_path
    end
  end

  private

  def check_activation
    return if @user.authenticated?(:activation, params[:activation_digest])

    handle_invalid_link
  end

  def load_user
    @user = User.find_by activation_digest: params[:activation_digest]
    return if @user

    handle_invalid_link
  end

  def handle_invalid_link
    flash.now[:danger] = t "email.activation.invalid_link"
    redirect_to root_path
  end
end
