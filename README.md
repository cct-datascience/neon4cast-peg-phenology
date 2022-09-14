# Predicting Phenology



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
