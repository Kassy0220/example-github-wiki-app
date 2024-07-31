class Minutes::ExportController < ApplicationController
  def create
    minute = Minute.find(params[:minute_id])
    GithubWikiManager.export_minute(minute)

    redirect_to minutes_url, notice: "GitHub Wikiに議事録を反映させました"
  end
end
