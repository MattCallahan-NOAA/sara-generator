library(lubridate)
#read template file
arrowtooth<-read.delim2("Annual_Arrowtooth_Biomass_GOA_Model_2023.dat", header=FALSE)

#read csv with my data
chla<-read.csv("Spring_Chlorophylla_Peak_GOA_Satellite.csv")

#define variables

indicator_name<-"Spring_Chlorophylla_Peak_GOA_Satellite"
submission_year<-lubridate::year(Sys.Date())
status_trends<-"chlorophyll bloom early this year"
factors<-"lots of clouds, low confidence in data this year (I am making this up)"
implications<-"The grazing zooplankton communities will gorge themselves into prodigous abundance to the delight of ravenous larval groundfish"
year<-chla$YEAR
indicator_value<-chla$DATA_VALUE

esplist<-list("#Ecosystem and Socioeconomic Profile (ESP) indicator contribution for stocks managed under the North Pacific Fisheries Management Council
#This template is required for updating ESP indicator contribution information  
#There are three required sections to check or update: Indicator Summary, Indicator Review, and Indicator Data  
#Please fill in the text (surrounded by quotes) or data as values in the line after each field marked with a # and capitalized name (e.g., #INTENDED_ESP, the next line should be ) 
#Note that several of the fields below may be static or only change occasionally, please review all fields when submitting the contribution
#Note that all fields are described in the Alaska ESP User Guide, please see [URL] for more details
#INDICATOR_SUMMARY -------------------------------------------------------------------------------------------------
#INDICATOR_NAME",
indicator_name,
"#STATUS_TRENDS - Information on the status and trends of the indicator similar to what is produced for an Ecosystem Status Report (ESR) contribution. (Limit to 4000 characters)",
status_trends,
"#FACTORS - Information on the factors that are influencing the status and trends of the indicator similar to what is produced for an Ecosystem Status Report (ESR) contribution. (Limit to 4000 characters)",
factors,
"IMPLICATIONS - Information on the implications",
implications,
"#INDICATOR_DATA ----------------------------------------------------------------------------------------------
#YEAR - List of years for the indicator contribution ",
year,
"#INDICATOR_VALUE - List of data values for the indicator contribuion (must match the year list length)",
indicator_value,
"#INDICATOR_ERROR - List of error estimates for the data values of the indicator contribution
NA
#INDICATOR_UCI - List of values for the upper confidence interval of the indicator contribution
NA
#INDICATOR_LCI - List of values for the lower confidence interval of the indicator contribution
NA
#OTHER_DATA - Total catch by year in metric tons 
NA"
)

#write 
lapply(esplist, write, "esp_txt_automated.txt", append=TRUE, ncolumns=1000)
