# frozen_string_literal: true

module UsersHelper
  def gravatar_for(user, options = { size: Settings["SIZE_OPTION_GRAVATAR"] })
    gravatar_url = "https://secure.gravatar.com/avatar/#{user.id}?s=#{options[:size]}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
