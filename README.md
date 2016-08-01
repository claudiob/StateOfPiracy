# StateOfPiracy


StatoOfPiracy (SoP) is a research project aimed to derive meaningful insights on the Online Piracy phenomenon.
We already publish in-depth analysis for some of our TOP clients, but we want to create an off-the-shelf research to be published on major media outlets.

First instance will be based on Italy (as a BETA country) since we have deep knowledge of the market to achieve some sort of verification on the empirical data.

## Aim of the research

The research will involve the following topics

* **Traffic and Popularity**
  * Top Piracy Websites
  * Traffic Estimate on Illegal/Shady websites
  * Legal vs Illegal vs Shady websites traffic compairson
* **CDNs**
  * Cloudflare vs non-Cloudflared services and role of Cloudflare
* **AS and Countries**
  * Top autonomous systems involved in Piracy
  * Top countries involved in Piracy
* **Advertising**
  * Advertising-Based websites
  * Top Advertising networks
  * (Advertised products and services)
  * Gross revenues estimate


## Project Steps

### Step 1: Getting Top Sites list

Stats on the most popular content within Italy will be derived by [Similarweb][sw], using two different statistics on the "Indystry Analysis" platform:

* Arts and Entairtainment / Italy ([here][1])

Notes:

* Cut-and-paste generate content that can be cleaned with regext 2 substitution: ^[0-9#]+(.*)$,  and #(.*) with nil;
* Content can be sorted and de-duplicated;

While Automated retrival of the contentent can be (supposedly) achieved via API (as well as XLS download in more-costly memberships), in this preliminary version data will be manually fetched and stored as CSV at the beginning of the process.  
  
Deliverables of this step are:

* A CSV list of the merged General/Movies top websites (~100 top will suffice)


### Step 2: Getting Traffic Data

In order to better understand data, each domain from Step 1 will be automatically analysed to derive meaningful data. Oonce again data for each domain name Italy (and overall) will be derived by [Similarweb][sw], using ollowing statistics:

* From [Main Window][3] for Last 6m: *Total Visits, Avg. Monthly Visits, Pages per Visit, Desktop/Mobile Percentages*;
* From [Geography][4]: *Italy Percentage*;
* (From [Traffic Overview][5]: *Direct, Google Search, Yahoo Search, Bing Search*);

While Automated retrival of the contentent can be via (costly) APIs, in this preliminary version data will fetched using Script Automation (Watir Webdriver) and stored as CSV at the beginning of the process. 

Notes:

* Implementation is done with Ruby [watir-webdriver](https://watirwebdriver.com/)
* Password are hard coded..... -_- (FIXME)

Deliverables of this step are:

* A CSV file with rows for each single domain with the following data:
  * Total Visits
  * Avg. Monthly Visits
  * Pages per Visit
  * Desktop Percentages
  * Mobile Percentages
  * Italy Traffic Percentage

### Step 3: Getting Network Data

Networing data will be derived, for each top domain, using automation.

Deliverables of this step are:

* A CSV file with following data for each domain (may be multiple rows):
  * A records IPs
  * AS for each IP
  * Country for each IP
  * Network Owner for each IP
  * Cloudflare Y/N flag

### Step 4: Getting Advertising Data

Advertising data will be derived using one of the following: wireshark, SSL MITM Proxy (Charlie), PhantomJs bindings.

Deliverables of this step are:

* A CSV file with following data for each domain (may be multiple rows):
  * Networks serving ADVs
  * Networks serving Tracking
  * Networks serving CDNed content

Support material in either DUMP and/or timestamped/elec.signed JSON content must be stored to prove data in a later occasion in a common format.

### Step 5: Graphs Creation & Data Fixing

In this step:

* Interpolating traffic with CPM to get gross revenues
* Preparing beautiful tables
* Preparing beautiful Visualisations
* ...magic!


[sw]: http://www.similarweb.com
[1]: https://pro.similarweb.com/#/industry/topsites/Arts_and_Entertainment/380/1m
[2]: https://pro.similarweb.com/#/industry/topsites/Arts_and_Entertainment~Movies/380/1m
[3]: https://pro.similarweb.com/#/website/audience-overview/altadefinizione.it/*/999/6m?webSource=Total
[4]: https://pro.similarweb.com/#/website/audience-geography/altadefinizione.it/*/999/6m
[5]: https://pro.similarweb.com/#/website/traffic-overview/altadefinizione.it/*/999/6m