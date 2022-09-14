# Predicting Phenology


The [GenoPhenoEnvo team](https://genophenoenvo.github.io/) submitted forecasts of forest phenology inferred from webcams to the [EFI Spring 2021, Fall 2021, and Spring 2022 Challenge](https://ecoforecast.org/efi-rcn-forecast-challenges/)s. Results for submitted forecasts can be viewed on the EFI-NEON Ecological Forecasting Challenge Dashboard, [here](https://shiny3.ecoforecast.org/).

## Background

> "The Ecological Forecasting Initiative is a grassroots consortium aimed at building and supporting an interdisciplinary community of practice around near-term (daily to decadal) ecological forecasts." - [ecoforecast.org/about](https://ecoforecast.org/about/){.uri}

The EFI-NEON Forecasting Challenge

> The National Science Foundation funded Ecological Forecasting Initiative Research Coordination Network (EFI-RCN) is hosting a NEON Ecological Forecast Challenge with the goal to create a community of practice that builds capacity for ecological forecasting by leveraging NEON data products. - [projects.ecoforecast.org/neon4cast-docs](https://projects.ecoforecast.org/neon4cast-docs)

This repository contains models used in the Phenology challenge, described in more detail the "Phenology" chapter of the [EFI-NEON Ecological Forecasting Challenge documentation](https://projects.ecoforecast.org/neon4cast-docs/Phenology.html).

EFI and the Phenology challenge are best described in the links above. In addition, you may be interested in the following resources:

-   The EFI [YouTube channel](https://www.youtube.com/channel/UCZ2KQdo1-FhNRtEBYxai5Aw), including the [Phenology challenge description](https://youtu.be/deWuTLGspJg) and an [overview of NEON data streams](https://youtu.be/3viG7QNGvK8).

-   Publications by Andrew Richardson et al. on the phenocams:

    -   Richardson, A., Hufkens, K., Milliman, T. et al. Tracking vegetation phenology across diverse North American biomes using PhenoCam imagery. Sci Data 5, 180028 (2018). <https://doi.org/10.1038/sdata.2018.28>

    -   Richardson, A.D. (2019), Tracking seasonal rhythms of plants in diverse ecosystems with digital camera imagery. New Phytol, 222: 1742-1750. <https://doi.org/10.1111/nph.15591>

## ETS Seasonal + Exponential Smoothing Model

The original aim of having a 'simple model' was work out the mechanisms of the forecast challenge. We call it 'simple' because these models have a single input - the historical time series of the variable (gcc or rcc) from 2016 through day t-1 to predict values of the variable through day t+1:t+180.

Although it started as a 'simple' moving window prediction, we later implemented an seasonal plus exponential smoothing model using the R forecast package.

Inputs and outputs were the same for both models. Neither model used gcc or rcc.

-   Inputs: historical time series of gcc or rcc from NEON Phenocam sites.
-   Outputs: daily, 35 day forecasts of gcc and rcc

This is not actually a simple model, it is in fact a very sophisticated Seasonally-adjusted exponential smoothing state-space model. In this case, it is only simple in that it is both univariate and easy to implement using the `forecast` R package (Hyndman & Khandakar, 2008) following the clear explanations provided in the Forecasting Principles and Practice text (Hyndman & Athanasopoulos, 2018).

Hyndman, R.J., & Athanasopoulos, G. (2018) Forecasting: principles and practice, 2nd edition, OTexts: Melbourne, Australia. OTexts.com/fpp2. Accessed on \<current date\>.

Hyndman RJ, Khandakar Y (2008). "Automatic time series forecasting: the forecast package for R." \_Journal of Statistical Software\_, \*26\*(3), 1-22. doi: 10.18637/jss.v027.i03 (URL:[https://doi.org/10.18637/jss.v027.i03).](https://doi.org/10.18637/jss.v027.i03).)

## Running in mybinder

You can run this repo as a "binder".  The [mybinder.org](https://mybinder.org) project will convert the repository into an interactive Rstudio sesson for you. To create a binder.  Use the link below but replace "eco4cast/neon4cast-example.git" with your repository. This is the exact R configuration that GitHub will be using to run your forecast.  The use of mybinder is primarily for testing. 

https://mybinder.org/v2/gh/cct-datascience/neon4cast-phenology.git/HEAD?urlpath=rstudio
