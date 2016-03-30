desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :environment do
    puts "Updating feed..."
    Infomation.updateURL
    puts "done."
end
 
task :send_reminders => :environment do
    Infomation.updateURL
end