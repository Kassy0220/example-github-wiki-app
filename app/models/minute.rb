class Minute < ApplicationRecord
  def title
    formatted_date = meeting_date.strftime('%Y年%m月%d日')
    "ふりかえり・計画ミーティング#{formatted_date}"
  end
end
