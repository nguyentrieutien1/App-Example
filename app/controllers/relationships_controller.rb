# frozen_string_literal: true

class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_user, only: :create
  before_action :load_relationship, only: :destroy

  def create
    handle_error_and_redirect(root_path, t("server.error_message")) do
      current_user.follow(@user)
      respond_to do |format|
        format.html { redirect_to @user }
        format.turbo_stream
      end
    end
  end

  def destroy
    handle_error_and_redirect(root_path, t("server.error_message")) do
      @user = @relationship.followed
      current_user.unfollow(@user)
      respond_to do |format|
        format.html { redirect_to @user }
        format.turbo_stream
      end
    end
  end

  private

  def load_user
    @user = User.find_by id: params[:followed_id]
    return if @user

    find_by_id_not_found t("not_found.user")
  end

  def load_relationship
    @relationship = Relationship.find_by id: params[:id]
    return if @relationship

    find_by_id_not_found t("not_found.user")
  end
end
