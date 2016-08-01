# load gems
require "bundler"
require "yaml"
require "csv"
require "json"
require "net/http"
require "resolv"
require "uri"

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

def getIps(domain)
  results = []

  dns_obj = Resolv::DNS.new( :nameserver => ['8.8.8.8', '8.8.4.4'] )

  res = dns_obj.getresources domain, Resolv::DNS::Resource::IN::A
  
  res.each do |r|
    results << r.address
  end
  
  results << nil
  results << nil
  results << nil
  results << nil
end

# Tait for login (pass is A7wjnp7PRa2pndYg )
puts "Please enter Data Prefix:"
prefix = gets
prefix = "2457590"

puts "Loading domains to scout..."
count = 0
CSV.open("./DATA/#{prefix}_step-3.csv", "wb", {:col_sep => ";"}) do |csv|
CSV.foreach("./DATA/#{prefix}_step-2.csv", {:col_sep => ";"}) do |origin|
    count +=1
    if count == 1
      csv << [origin[0], origin[1], origin[2], origin[3], origin[4], origin[5], origin[6], origin[7], origin[8], origin[9], origin[10], origin[11], origin[12],  "IP1" , "IP2", "IP3"]
    else
      puts origin[0]
      domain = origin[0]
      results = getIps(domain)
      csv <<  [origin[0], origin[1], origin[2], origin[3], origin[4], origin[5], origin[6], origin[7], origin[8], origin[9], origin[10], origin[11], origin[12], results[0], results[1], results[2]]
    end
  end
end

__END__
