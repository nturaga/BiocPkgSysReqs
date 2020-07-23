List of all system requirements needed by all Bioconductor packages

```
!> print(tbl_cp %>% select(sysreqs) %>% distinct(), n = 48)
 # A tibble: 48 x 1
    sysreqs
    <chr>
  1 perl
  2 libcairo2-dev
  3 libicu-dev
  4 pandoc
  5 libxml2-dev
  6 make
  7 libcurl4-openssl-dev
  8 imagemagick
  9 libmagick++-dev
 10 libfreetype6-dev
 11 libglu1-mesa-dev
 12 libpng-dev
 13 libgl1-mesa-dev
 14 zlib1g-dev
 15 libjpeg-dev
 16 libglpk-dev
 17 libgmp3-dev
 18 libssl-dev
 19 libssh2-1-dev
 20 git
 21 libv8-dev
 22 pandoc-citeproc
 23 python
 24 default-jdk
 25 tcl
 26 tk
 27 tk-dev
 28 tk-table
 29 libfontconfig1-dev
 30 jags
 31 libtiff-dev
 32 libgsl0-dev
 33 libmysqlclient-dev
 34 mysql-server
 35 libatk1.0-dev
 36 libglib2.0-dev
 37 libgtk2.0-dev
 38 libpango1.0-dev
 39 libnetcdf-dev
 40 libpq-dev
 41 libproj-dev
 42 libmpfr-dev
 43 libgdal-dev
 44 gdal-bin
 45 libgeos-dev
 46 texlive
 47 swftools
 48 libsasl2-dev
 ```
