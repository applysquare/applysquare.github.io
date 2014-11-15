desc "compile and run the site"
task :default do
  pids = [
    spawn("jekyll serve --watch --drafts --config _config.yml,_debug.yml"),
    spawn("make watch"),
  ]
 
  trap "INT" do
    Process.kill "INT", *pids
    exit 1
  end
 
  loop do
    sleep 1
  end

end
