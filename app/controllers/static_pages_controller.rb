# frozen_string_literal: true

class StaticPagesController < ApplicationController
  before_action :logged_in?, only: :home

  def home
    @micropost = @current_user.microposts.build
    @pagy, @microposts = pagy current_user.feed, items: Settings["PERPAGE_5"]
  end

  def help; end
end
