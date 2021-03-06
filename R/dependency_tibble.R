library(BiocManager)
library(tidyverse)
library(BiocPkgSysReqs)

repositories <- BiocManager::repositories()

db0 <- available.packages(repos = repositories[c("BioCsoft", "CRAN")])

bioc <- available.packages(repos = repositories()["BioCsoft"])

cran <- available.packages(repos = repositories()["CRAN"])

deps <- tools::package_dependencies(rownames(bioc), db0, recursive = TRUE)

uldeps <- unlist(deps, use.names = FALSE)
is_cran <- uldeps %in% rownames(cran)
is_cran_by_bioc_pkg <- relist(is_cran, deps)


tbl <-
    tibble(
        bioc_package = rep(names(deps), lengths(deps)),
        dependency = unlist(deps, use.names = FALSE)
    ) %>%
    mutate(
        is_cran = dependency %in% rownames(cran)
    )

cran_deps <-
    filter(tbl, is_cran) %>%
    dplyr::count(dependency, sort = TRUE)

## BiocManager::install('nturaga/BiocPkgSysReqs')
sysreqs <- BiocPkgSysReqs::rspm_get_sysreqs()

sys_pkgs <-
    cran_deps %>%
    left_join(sysreqs, by = c("dependency" = "name")) %>%
    filter(!is.na(packages))
