class Minutes::ExportController < ApplicationController
  def create
    minute = Minute.find(params[:minute_id])
    Git.clone(ENV['GITHUB_WIKI_URL'], 'wiki_repositories') unless Dir.exist?('wiki_repositories')

    repository_directory = Rails.root.join('wiki_repositories')
    filepath = "#{repository_directory}/#{minute.title}.md"
    File.open(filepath, 'w+') do |file|
      file.puts minute.content # 実際のアプリでは、Markdownの末尾に空行があるため、writeでファイルに書き込む
    end

    git = Git.open('./wiki_repositories', log: Logger.new(STDOUT))
    git.pull
    git.add("#{minute.title}.md")
    git.commit("#{minute.title}.mdを作成")
    git.push('origin', 'master')
    # TODO: 例外が発生した時の処理を書く

    redirect_to minutes_url, notice: "GitHub Wikiに出力が完了しました"
  end
end
