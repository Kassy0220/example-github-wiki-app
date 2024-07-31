class GithubWikiManager
  WORKING_DIRECTORY = Rails.root.join('wiki_repositories').freeze

  def self.export_minute(minute)
    new.export_minute(minute)
  end

  def initialize
    @git = Dir.exist?(WORKING_DIRECTORY) ? Git.open(WORKING_DIRECTORY, log: Logger.new(STDOUT))
                                         : Git.clone(ENV['GITHUB_WIKI_URL'], WORKING_DIRECTORY)
    set_github_account
  end

  def set_github_account
    @git.config('user.name', ENV['GITHUB_USER_NAME'])
    @git.config('user.email', ENV['GITHUB_USER_EMAIL'])
  end

  def export_minute(minute)
    # TODO: 例外が発生した時の処理を書く
    @git.pull
    commit_minute(minute)
    @git.push('origin', 'master')
  end

  def commit_minute(minute)
    filepath = "#{WORKING_DIRECTORY}/#{minute.title}.md"
    File.open(filepath, 'w+') do |file|
      file.puts minute.content # 実際のアプリでは、Markdownの末尾に空行があるため、writeでファイルに書き込む
    end

    @git.add("#{minute.title}.md")
    @git.commit("#{minute.title}.mdを作成")
  end
end
