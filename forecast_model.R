library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)
library(data.table)
library(forecast)


file <- 'https://data.ecoforecast.org/neon4cast-targets/phenology/phenology-targets.csv.gz'

# now contains both gcc_90 and rcc_90
gcc_raw <- fread(file)

#i <- 1
#for(i in 0){
now <- Sys.Date() 
horizon <- 35 # number of days to forecast
this_month <- month(now)
this_day <- day(now)

end <- now + days(horizon)
end_month <- month(end)
end_day <- day(end)

middle_month <- ifelse(end_month - this_month == 2, this_month + 1, 0)

gcc <- gcc_raw %>% 
  pivot_wider(id_cols = c(datetime, site_id), 
              names_from = variable, 
              values_from = observed) %>% 
  mutate(month = month(datetime), year = year(datetime), day = day(datetime), doy = yday(datetime))

readr::write_csv(gcc, 'gcc.csv')

# BEGIN Simple Seasonal + Exponential Smoothing Model
gcc_wide <- gcc %>% 
  dplyr::select(datetime, site_id, gcc_90) %>% 
  pivot_wider(id_cols = datetime, names_from = site_id, values_from = gcc_90) %>% 
  dplyr::select(-datetime) 

rcc_wide <- gcc %>% 
  dplyr::select(datetime, site_id, rcc_90) %>% 
  pivot_wider(id_cols = datetime, names_from = site_id, values_from = rcc_90) %>% 
  dplyr::select(-datetime)

gcc_ts <- ts(gcc_wide, frequency = 365)
rcc_ts <- ts(rcc_wide, frequency = 365)

gcc_future <- forecast(gcc_ts, h = 35, level = c(0.3, 0.7))
rcc_future <- forecast(rcc_ts, h = 35, level = c(0.3, 0.7))

gcc_preds_wide <- gcc_future %>% 
  as.data.frame %>% 
  mutate(sigma = (`Hi 30` - `Lo 30`)/2) %>% 
  rename(site_id = Series, mu = `Point Forecast`) %>% 
  dplyr::mutate(datetime = rep(now + days(1:horizon), length(unique(site_id)))) %>% 
  dplyr::select(datetime, site_id, mu, sigma)

rcc_preds_wide <- rcc_future %>% 
  as.data.frame %>%  
  mutate(sigma = (`Hi 30` - `Lo 30`)/2) %>% 
  rename(site_id = Series, mu = `Point Forecast`) %>% 
  dplyr::mutate(datetime = rep(now + days(1:horizon), length(unique(site_id)))) %>% 
  dplyr::select(datetime, site_id, mu, sigma)

# END Simple Seasonal + Exponential Smoothing Model

gcc_preds <- gcc_preds_wide %>%  
  mutate(variable = 'gcc_90') %>% 
  tidyr::pivot_longer(cols = c('mu', 'sigma'), 
                      names_to = 'parameter', values_to = 'predicted')
rcc_preds <- rcc_preds_wide %>%  
  mutate(variable = 'rcc_90') %>% 
  tidyr::pivot_longer(cols = c('mu', 'sigma'), 
                      names_to = 'parameter', values_to = 'predicted')

preds <- bind_rows(gcc_preds, rcc_preds) %>% 
#  left_join(rcc_preds, by = c("datetime", "site_id", "parameter")) %>% 
  mutate(reference_datetime = now,
         family = 'normal')

pred_filename <- paste('phenology', year(now),  
                       sprintf("%02d", this_month),  
                       sprintf("%02d", this_day), 
                       'PEG.csv', sep = '-')
readr::write_csv(preds, file = pred_filename)

neon4cast::submit(forecast_file = pred_filename, 
                  metadata = NULL, ask = FALSE)
