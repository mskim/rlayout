
require 'sinatra'
require 'slim'

REPOS_PATH = "/Users/mskim/repos_path"

get "/" do
  slim :index 
  
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

get "/pdf/:email/:project" do
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


__END__

@@layout 
doctype html 
html
  head 
    meta charset="utf-8" 
    title Just Do It 
    link rel="stylesheet" media="screen, projection" href="/styles.css" 
    /[if lt IE 9] 
      script src="http://html5shiv.googlecode.com/svn/trunk/html5.js" 
  body 
    h1 Just Do It 
    == yield 

@@index 
h2 My Tasks
ul.tasks
  li Get Milk