# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create)
  before_action :load_user, except: %i(new create index)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy User.sorted_by_name, items: Settings["PERPAGE_5"]
  end

  def show
    @page, @microposts = pagy @user.microposts, items: Settings["PERPAGE_5"]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "email.activation.subject"
      redirect_to root_url, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t("update.user.success_message", name: t("update.user.label_name"))
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "delete.user.success_message", name: t("delete.user.label_name")
      redirect_to users_path
    else
      flash[:danger] = t "delete.user.fail_message"
      redirect_to root_path
    end
  end

  private

  def admin_user
    return if current_user.admin?

    flash[:danger] = t "auth.permission_error_message"
    redirect_to root_path
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "not_found.user"
    redirect_to root_url
  end

  def correct_user
    return if @user == current_user

    flash[:danger] = t "auth.permission_error_message"
    redirect_to root_url
  end

  def user_params
    params.permit(:name, :birthday, :password, :password_confirmation)
  end
end
