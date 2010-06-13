require 'test_helper'

RAILS_ASSET_ID = 'REV_TEST'
CONTENT_TYPES   = {
                    :jpg => 'image/jpeg',
                    :png => 'image/png',
                    :gif => 'image/gif',
                    :css => 'text/css',
                    :js  => 'text/javascript'
                  }
REGEX_ROOT_RELATIVE_CSS_URL = /url\((\'|\")?(\/+.*(#{CONTENT_TYPES.keys.map { |k| '\.' + k.to_s }.join('|')}))\1?\).*/
REPLACEMENT = "url(\1#{RAILS_ASSET_ID}\2\1)"

class MorningGloryTest < ActiveSupport::TestCase

  test "CSS URL replacment" do
    assert_equals "background: url(/images/test.png)".gsub(REGEX_ROOT_RELATIVE_CSS_URL, REPLACEMENT), ""
  end 
  
end
