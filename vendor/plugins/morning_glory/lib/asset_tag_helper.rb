require 'action_view/helpers/asset_tag_helper'

module ActionView::Helpers::AssetTagHelper


    def rewrite_asset_path(source, path = nil)
      if path && path.respond_to?(:call)
        return path.call(source)
      elsif path && path.is_a?(String)
        return path % [source]
      end

      asset_id = rails_asset_id(source)
      if asset_id.blank?
        source
      else
       # AB: As of June AWS Cloudfront supports HTTPS requests. This alternative code path should now be redundant.
        # # If the request isn't SSL, or if the request is SSL and the SSL host is set
        # if !request.ssl? || (request.ssl? && !AssetHostingWithMinimumSsl::asset_ssl_host.empty?)
        #   File.join('/', ENV['RAILS_ASSET_ID'], source)
        # else
        #   source + "?#{asset_id}"
        # end
        File.join('/', ENV['RAILS_ASSET_ID'], source)
      end
    end


end