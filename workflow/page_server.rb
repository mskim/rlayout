
require 'sinatra'
REPOS_PATH = "/Users/mskim/repos_path"

get "/" do
  "Welcome to PageServer..."
end

get "/process/:email/:project" do
  repo = REPOS_PATH + "/#{params[:email]}/#{params[:project]}"
  unless File.directory?(repo)
    "project #{repo} not found !!! "
  else
    "we are processing #{repo}"
    # system "(cd #{repo} && git pull && rake)"
    # sleep 10
    # system "(cd #{repo} && git push)"
  end
end

get "/print/:email/:project" do
  repo = REPOS_PATH + "/#{params[:email]}/#{params[:project]}"
  unless File.directory?(repo)
    "project #{repo} not found !!! "
  else
    "we are processing #{repo}"
  end
end

get "/print_reday/:email/:project" do
  repo = REPOS_PATH + "/#{params[:email]}/#{params[:project]}"
  # system "(cd #{repo} && git pull && rake print_ready)"
  # sleep 10
  # system "(cd #{repo} && git push)"
end