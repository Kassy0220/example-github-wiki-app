class GithubWikiManager
  WORKING_DIRECTORY = Rails.root.join('wiki_repositories').freeze

  def self.export_minute(minute)
    new.export_minute(minute)
  end

  def initialize
    @git = Dir.exist?(WORKING_DIRECTORY) ? Git.open(WORKING_DIRECTORY, log: Logger.new(STDOUT))
                                         : Git.clone(ENV['GITHUB_WIKI_URL'], WORKING_DIRECTORY)
    set_github_account
    create_credential_file
  end

  def set_github_account
    @git.config('user.name', ENV['GITHUB_USER_NAME'])
    @git.config('user.email', ENV['GITHUB_USER_EMAIL'])
  end

  def create_credential_file
    credential_file_path = Rails.root.join('.netrc')
    return if File.exist?(credential_file_path)

    content = <<-CREDENTIAL
machine github.com
login #{ENV['GITHUB_USER_NAME']}
passwd #{ENV['GITHUB_ACCESS_TOKEN']}
    CREDENTIAL

    File.open(credential_file_path, 'w+') do |file|
      file.puts content
    end
    File.chmod(0600, credential_file_path)
  end

  def export_minute(minute)
    # TODO: 例外が発生した時の処理を書く
    @git.pull
    Rails.logger.info "git pullが実行されました"
    commit_minute(minute)
    credential_file_exists = File.exist?(Rails.root.join('.netrc'))
    Rails.logger.info "#{credential_file_exists ? '認証ファイルが存在します' : '認証ファイルが存在しません'}"
    @git.push('origin', 'master')
    Rails.logger.info "git pushが実行されました"
  end

  def commit_minute(minute)
    filepath = "#{WORKING_DIRECTORY}/#{minute.title}.md"
    File.open(filepath, 'w+') do |file|
      file.puts minute.content # 実際のアプリでは、Markdownの末尾に空行があるため、writeでファイルに書き込む
    end

    @git.add("#{minute.title}.md")
    Rails.logger.info "git addが実行されました"
    @git.commit("#{minute.title}.mdを作成")
    Rails.logger.info "git commitが実行されました"
  end
end
