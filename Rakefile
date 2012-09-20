desc "generate and update gh-pages"
task :pages do

  puts %x{ bundle exec rspec }
  puts %x{ bundle exec yardoc --protected ./lib/**/*.rb }
  puts %x{ mv -v ./doc /tmp }
  puts %x{ mv -v ./coverage /tmp }
  puts %x{ git checkout gh-pages }
  puts %x{ mv -v /tmp/doc . }
  puts %x{ mv -v /tmp/coverage . }
  puts %x{ git commit --all -m "updating doc and coverage" }
  puts %x{ git checkout - }
  puts "don't forget to run: git push origin gh-pages"

end
