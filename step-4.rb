# load gems
require "bundler"
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


def getASN(ip)
  results = []
  begin
    whois = `whois -h whois.cymru.com " -v #{ip}"`
    whois = whois.split("\n")[1].split("|")
    whois.each do |i|
      results << i.strip
    end
  rescue
  end
  results << nil
  results << nil
  results << nil
  results << nil
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

CSV.open("./DATA/#{prefix}_step-4.csv", "wb", {:col_sep => ";"}) do |csv|
CSV.foreach("./DATA/#{prefix}_step-3.csv", {:col_sep => ";"}) do |origin|
    count +=1
    if count == 1
      csv << [origin[0], origin[1], origin[2], origin[3], origin[4], origin[5], origin[6], origin[7], origin[8], origin[9], origin[10], origin[11], origin[12], origin[13], "ASN1", "Netblock1", "Country1", "Company1", origin[14], "ASN2", "Netblock2", "Country2", "Company2", origin[15], "ASN3", "Netblock3", "Country3", "Company3",]
    else
      
      puts "\tMining: #{origin[0]}"
      
      results = getASN(origin[13])
      asn_1 = results[0]
      nb_1  = results[2]
      cou_1 = results[3]
      com_1 = results[6]      
      results = getASN(origin[14])
      asn_2 = results[0]
      nb_2  = results[2]
      cou_2 = results[3]
      com_2 = results[6]      
      results = getASN(origin[15])
      asn_3 = results[0]
      nb_3  = results[2]
      cou_3 = results[3]
      com_3 = results[6]      

      csv << [origin[0], origin[1], origin[2], origin[3], origin[4], origin[5], origin[6], origin[7], origin[8], origin[9], origin[10], origin[11], origin[12], origin[13], asn_1, nb_1, cou_1, com_1, origin[14], asn_2, nb_2, cou_2, com_2, origin[15], asn_3, nb_3, cou_3, com_3]
    end
  end
end

__END__
