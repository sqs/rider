namespace "doc" do
  desc "Generate RDoc docs"
  task :generate do
    # Using rake/rdoctask invoked old rdoc 1.x for some reason, but this invokes rdoc 2.x
    sh "rdoc --all --title 'Rider - Ruby Web crawler' --line-numbers --inline-source --force-update --all --charset utf-8 --main README README lib/"
  end

  desc "Upload docs to site"
  task :upload do
    sh "tar czfv rider-rdoc.tgz doc/"
    puts
    puts "Going to upload..."
    puts
    sh "scp rider-rdoc.tgz cardinal.stanford.edu:WWW/rider/"
    sh "ssh cardinal.stanford.edu 'cd WWW/rider;tar xzfv rider-rdoc.tgz'"
    sh "rm rider-rdoc.tgz"
    puts
    puts "Upload complete"
  end
  
  desc "Generate & upload"
  task :update=>[:generate, :upload]
end


