desc "generate and update gh-pages"
task :pages do

  puts %x{ set -x; bundle exec rspec }
  puts %x{ set -x; bundle exec yardoc --protected ./lib/**/*.rb }
  puts %x{ set -x; mv -v ./doc /tmp }
  puts %x{ set -x; mv -v ./coverage /tmp }
  puts %x{ set -x; git checkout gh-pages }
  puts %x{ set -x; mv -v /tmp/doc . }
  puts %x{ set -x; mv -v /tmp/coverage . }
  puts %x{ set -x; git add . } 
  puts %x{ set -x; git commit --all -m "updating doc and coverage" }
  puts %x{ set -x; git checkout master }
  puts "don't forget to run: git push origin gh-pages"

end
