# load gems
require "bundler"
require "yaml"

Bundler.setup
Bundler.require :default

# Script has 3 different actions performed:
# 
# Step1 : Fetch all the pages and save them
# Step2 : Parse all the pages
# Step3 : Save results


# ****************************************************************************
# STEP 1
# ****************************************************************************

# Load all domains.
# Data is supposed to be in step1.txt

domains = []

puts "Loading domains to scout..."
f = File.open("./failed.txt", "r") rescue f = File.open("./DATA/step1.txt", "r")
f.each_line do |domain|
  domains << domain
end
puts "   ...#{domains.size} loaded"

# Instantiate Watir
b = Watir::Browser.new :chrome
b.goto "https://www.similarweb.com/"

# Tait for login (pass is A7wjnp7PRa2pndYg )
puts "Please Login and press ENTER key..."
gets

count = 0

domains.each do |d|
  count +=1
  puts "Processing #{count}/#{domains.size}: #{d}"
  filename = "#{DateTime.now.jd}_#{d.to_url}"
  b.goto "https://pro.similarweb.com/#/website/audience-overview/#{d}/*/999/6m?webSource=Total"
  sleep 5
  File.open("./DATA/#{filename}_tot.yaml", "w") { |file| YAML.dump(b.html, file) }
  puts "   \t#{filename} TOTAL: OK"
  b.goto "https://pro.similarweb.com/#/website/audience-geography/#{d}/*/999/6m"
  sleep 5
  File.open("./DATA/#{filename}_aud.yaml", "w") { |file| YAML.dump(b.html, file) }
  puts "   \t#{filename} AUDIENCE: OK"
  b.goto "https://pro.similarweb.com/#/website/traffic-overview/#{d}/*/999/6m"
  sleep 8
  File.open("./DATA/#{filename}_ref.yaml", "w") { |file| YAML.dump(b.html, file) }    
  puts "   \t...#{filename} REFERRAL: OK"
  sleep 2
end

__END__
noko = Nokogiri::HTML.parse(page)

totalVisits = page.match(/class=\"graphtabs-tab-value ng-binding(.*)/m)

pagesPerVisit = noko.xpath('/html/body/div[1]/div/div/div[1]/div/div[3]/div/section/div/div/div[2]/div[5]/new-widget/div/div/div/div[1]/div/sw-widget-utility/sw-widget-utility-graph-tabs/div/div[3]/div[2]/div[1]')

percentageDesktop = noko.xpath('//*[@id="highcharts-0"]/div/div/div/div[1]/span/div/span[2]')

totalVisits = noko.xpath('/html/body/div[1]/div/div/div[1]/div/div[3]/div/section/div/div/div[2]/div[2]/new-widget/div/div/div/div[2]/div/div/div/div[2]')

puts "totalVisits: #{totalVisits}
pagesPerVisit: #{pagesPerVisit}
percentageDesktop: #percentageDesktop
totalVisits: #{totalVisits}"
