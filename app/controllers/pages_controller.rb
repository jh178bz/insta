class PagesController < ApplicationController
  def home
    if user_signed_in?
      @post  = current_user.posts.build
      if params[:q]
        @feed_items = Post.search_by_keyword(params[:q])
                        .paginate(page: params[:page])
      else
        @feed_items = current_user.feed.paginate(page: params[:page])
      end
    end
  end

  def terms
  end

  def about
  end

  def contact
  end
end
