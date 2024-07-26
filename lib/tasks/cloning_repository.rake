namespace :cloning_repository do
  desc 'Clone GitHub Wiki.'
  task :cloning_github_wiki => :environment do
    git = Git.clone(ENV['GITHUB_WIKI_URL'], 'example_wiki')
    Rails.logger.info git.config
  end
end
