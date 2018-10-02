FROM rocker/tidyverse:3.4.4
# FROM artemklevtsov/r-alpine:3.4.4

# install packrat
RUN R -e 'install.packages("packrat", repos="http://cran.rstudio.com", dependencies=TRUE, lib="/usr/local/lib/R/site-library");'

USER rstudio

# copy lock file & install deps
COPY --chown=rstudio:rstudio packrat/packrat.* /home/rstudio/project/packrat/

# install dependencies
RUN R -e 'packrat::restore(project="/home/rstudio/project");'

# copy the rest of the project
# .dockerignore can ignore some files/folders if desirable
COPY --chown=rstudio:rstudio . /home/rstudio/project

# build and check package
RUN R -e 'devtools::check(project="/home/rstudio/project");'

# USER root
WORKDIR /home/rstudio/project
EXPOSE 8080
CMD ["/usr/local/bin/RScript", "/home/rstudio/project/R/app.R"]
