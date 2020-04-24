FROM rocker/tidyverse:latest

# Setup Python env
RUN apt-get update
RUN apt-get install -y libpython-dev
RUN apt-get install -y libpython3-dev
RUN apt-get install -y python-pip
RUN pip install virtualenv

# Install R packages and dependencies
RUN R -e 'install.packages("devtools")'
RUN R -e 'devtools::install_github("https://github.com/magnusfurugard/featuretoolsR")'

# Attempt to setup virtualenv
RUN R -e 'library(featuretoolsR)'
RUN R -e 'library(featuretoolsR); install_featuretools()'
RUN R -e 'library(featuretoolsR); list_primitives()'
