#POST
library(tidyverse)
library(keyring)
library(jsonlite)
library(httr)

# If you use the keyring package
secret <- jsonlite::base64_enc( key_get("akfin_secret") )


# Get token from API
req <- httr::POST("https://apex.psmfc.org/akfin/data_marts/oauth/token",
                  httr::add_headers(
                    "Authorization" = paste("Basic", gsub("\n", "", secret)),
                    "Content-Type" = "application/x-www-form-urlencoded;charset=UTF-8"
                  ),
                  body = "grant_type=client_credentials"
);

#  Create authentication error message
httr::stop_for_status(req, "Something broke.")
token <- paste("Bearer", httr::content(req)$access_token)


# load chla
chla <- read.csv("chlor-test.csv")
atf <- read.csv("atf_test.csv")


# post the first one
POST("https://apex.psmfc.org/akfin/data_marts/test/esp_ts_test",
     body = chla,
     add_headers(Authorization = token),
     encode = "json"
)

# pull from test module
esp_ts<-fromJSON(content(
  GET('https://apex.psmfc.org/akfin/data_marts/test/esp_ts_test',
      add_headers(Authorization = token)),
  as="text", encoding="UTF-8")) %>%
  bind_rows()

# post the next one
POST("https://apex.psmfc.org/akfin/data_marts/test/esp_ts_test",
     body = atf,
     add_headers(Authorization = token),
     encode = "json"
)

# pull from test module
esp_ts<-fromJSON(content(
  GET('https://apex.psmfc.org/akfin/data_marts/test/esp_ts_test',
      add_headers(Authorization = token)),
  as="text", encoding="UTF-8")) %>%
  bind_rows()

## NOW UPLOAD METADATA
pcod <- read.csv("pcod.csv") %>% dplyr::select(-AKFIN_LOAD_DATE)
hw <- read.csv("heatwavetest.csv") %>% dplyr::select(-AKFIN_LOAD_DATE)

POST("https://apex.psmfc.org/akfin/data_marts/test/esp_sum_test",
     body = pcod,
     add_headers(Authorization = token),
     encode = "json"
)

POST("https://apex.psmfc.org/akfin/data_marts/test/esp_sum_test",
     body = hw,
     add_headers(Authorization = token),
     encode = "json"
)

esp_sum<-fromJSON(content(
  GET('https://apex.psmfc.org/akfin/data_marts/test/esp_sum_test',
      add_headers(Authorization = token)),
  as="text", encoding="UTF-8")) %>%
  bind_rows()
