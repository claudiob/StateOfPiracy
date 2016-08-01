# load gems
require "bundler"
require "yaml"
require "csv"

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

XPATH_VISITS =            ""
XPATH_PAGES_PER_VISITS =  ""
XPATH_AVG =               ""


class StringDecoder
  # Hash with powers of 10 by names
  POWERS = {
    't' => 10**12,
    'T' => 10**12,
    'b' => 10**9,
    'B' => 10**9,
    'm' => 10**6,
    'M' => 10**6,
    'k' => 10**3,
    'K' => 10**3,
  }.freeze

  # Only one public method for service object: #call
  def call(input)
    input = input.gsub("K", " K").gsub("k", " k").gsub("M", " M").gsub("m", " m").gsub("B", " B").gsub("b", " b").gsub("T", " T").gsub("t", " t")
    # Return if input is numeric (and don't forget to strip spaces and commas)
    return input.gsub(/[\s,]/, '').to_f if float? input.gsub(/[\s,]/, '')

    result = 0

    # First line: insert spacebar if there is no one between integer and word
    # Second line: split array by space
    # Third line: convert each word to its numeric format
    # Fourth line: slice array by 2 elements
    # Fifth line: multiply each chunk and sum everything
    input.gsub(/(?<=[\d])(?=[а-яА-Я])/, ' ')
         .split(' ')
         .map { |i| POWERS[i] ? POWERS[i].to_f : i.to_f }
         .each_slice(2) do |slice|
      result += slice.inject(:*)
    end

    result
  end

  private

  # Check if given string may be converted to float
  def float?(input)
    input[/\A[\d]+[\.]?[\d]*\z/] == input
  end
end

$FAILED = []

def normalize(data)
  decoder = StringDecoder.new
  data = decoder.call(data.text.to_s.strip).to_f
#  data = data.to_s.strip.gsub("K", "000").gsub("M", "00.000").gsub("B", "00.000.000")
end

domains = []
failed = []

puts "Loading domains to scout..."
f = File.open("./DATA/step1.txt", "r")
f.each_line do |domain|
  domains << domain
end
puts "   ...#{domains.size} loaded"

# Tait for login (pass is A7wjnp7PRa2pndYg )
puts "Please enter Data Prefix:"
prefix = gets
prefix = "2457590"

CSV.open("./DATA/#{prefix}_step-2.csv", "wb", {:col_sep => ";"}) do |csv|
  csv << ["Domain", "Total Visits", "Average m Visits", "Italy Percentage", "Pages per View", "6m Pageviews Italy", "Source Direct", "Source Mail", "Source Referral", "Source Social", "Source Organic", "Source Paid Search", "Source Paid Display"]

  domains.each do |d|
    d.strip!
    page = File.open("./DATA/#{prefix}_#{d.to_url}_tot.yaml") { |file| YAML.load(file) }
    geo  = File.open("./DATA/#{prefix}_#{d.to_url}_aud.yaml") { |file| YAML.load(file) }
    ref  = File.open("./DATA/#{prefix}_#{d.to_url}_ref.yaml") { |file| YAML.load(file) }
  
    noko = Nokogiri::HTML.parse(page)
    noko_geo = Nokogiri::HTML.parse(geo)  
    noko_ref = Nokogiri::HTML.parse(ref)  
  
    pagesPerVisit = normalize noko.xpath('/html/body/div[1]/div/div/div[1]/div/div[3]/div/section/div/div/div[2]/div[5]/new-widget/div/div/div/div[1]/div/sw-widget-utility/sw-widget-utility-graph-tabs/div/div[3]/div[2]/div[1]/text()')

    avgMonthly      = normalize noko.xpath('/html/body/div[1]/div/div/div[1]/div/div[3]/div/section/div/div/div[2]/div[5]/new-widget/div/div/div/div[1]/div/sw-widget-utility/sw-widget-utility-graph-tabs/div/div[1]/div[2]/div[1]/text()')
    totalVisits     = normalize noko.xpath('/html/body/div[1]/div/div/div[1]/div/div[3]/div/section/div/div/div[2]/div[2]/new-widget/div/div/div/div[2]/div/div/div/div[1]/text()')
    avgMonthly      = avgMonthly * 6
    
    italy           = normalize noko_geo.xpath("*/descendant::td[text()='Italy']/following-sibling::td[1]/div/div")

    ref_direct      = normalize noko_ref.xpath('//*[@id[starts-with(.,"highcharts-")]]/div[3]/div[1]/span')
    ref_mail        = normalize noko_ref.xpath('//*[@id[starts-with(.,"highcharts-")]]/div[3]/div[2]/span')
    ref_referrals   = normalize noko_ref.xpath('//*[@id[starts-with(.,"highcharts-")]]/div[3]/div[3]/span')
    ref_social      = normalize noko_ref.xpath('//*[@id[starts-with(.,"highcharts-")]]/div[3]/div[4]/span')
    ref_organic     = normalize noko_ref.xpath('//*[@id[starts-with(.,"highcharts-")]]/div[3]/div[5]/span')
    ref_paid_search = normalize noko_ref.xpath('//*[@id[starts-with(.,"highcharts-")]]/div[3]/div[6]/span')
    ref_display_ads = normalize noko_ref.xpath('//*[@id[starts-with(.,"highcharts-")]]/div[3]/div[7]/span')
    pageViews     = avgMonthly * pagesPerVisit / 100 * italy
    
    if totalVisits == 0 || pagesPerVisit == 0 || italy == 0
      failed << d
    end
    
    italy = 0.01 if italy == 0
    
    csv << [d, totalVisits.to_i, avgMonthly, italy, pagesPerVisit, pageViews.to_i, ref_direct, ref_mail, ref_referrals, ref_social, ref_organic, ref_paid_search, ref_display_ads]

    puts "  *********************************************
       #{d.strip}
  *********************************************
  totalVisits: #{totalVisits}
  pagesPerVisit: #{pagesPerVisit}
  avgMonthly: #{avgMonthly}
  italy: #{italy}
  pageViews:#{pageViews}
  ---
  ref_direct: #{ref_direct}
  ref_mail: #{ref_mail}
  ref_referrals: #{ref_referrals}
  ref_social: #{ref_social}
  ref_organic: #{ref_organic}
  ref_paid_search: #{ref_paid_search}
  ref_display_ads: #{ref_display_ads}
  \n\n"
   
  end
end

file = File.open("./FAILED.txt", "w")
failed.each do |f|
  file.write(f + "\n")
end
file.close

__END__
