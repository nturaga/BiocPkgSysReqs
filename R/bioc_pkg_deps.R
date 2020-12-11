.bioc_software_packages <- function() {
    available.packages(
        repos = BiocManager::repositories()[["BioCsoft"]]
    )
}

.cran_packages <- function() {
    available.packages(repos = BiocManager::repositories()[["CRAN"]])
}

.db <- function() {
    db <- available.packages(
        repos = BiocManager::repositories()
    )
}

.pkg_deps_all <-
    function(bioc_software_packages, db)
{
    pkgs <- tools::package_dependencies(
                       rownames(bioc_software_packages),
                       db=db,
                       which=c("Depends", "Suggests")
                   )
    pkgs
}


pkg_deps_all <- .pkg_deps_all(.bioc_software_packages(), .db())

#' @rdname bioc_pkg_sys_reqs
#'
#' @description Get system requirements of Bioconductor package's
#'     CRAN dependencies.
#'
#' @param package_name character(1) vector of Bioconductor
#'     package names.
#'
#' @return tibble
#'
#' @examples
#'
#' @importFrom tibble tibble
#'
#' @export
bioc_pkg_sys_reqs <-
    function(package_name, pkg_deps_all, cran)
{
    ## validity checks
    if(missing(package_name) || !.is_character(package_name)) {
        stop("the argument 'package_name' takes a character vector",
             "of Bioconductor package names.")
    }
    ## Get bioc packages

    ## Get cran packages

    ## Get database for package_dependencies

    ## Get package_dependencies of all bioc pkgs

    ## Get all dependencies of packages
    all_deps <- unname(
        unlist(pkg_deps_all[package_name])
    )

    ## Get only cran dependencies
    cran_deps <- all_deps[all_deps %in% rownames(cran)]

    ## Make tibble with results
    result <- tibble(sysreqs = character())
    for (cran_pkg in cran_deps) {
        tbl <- rspm_get_package_sysreqs(package_name = cran_pkg)
        result <- bind_rows(result, tbl)
    }

    result
}
# which(sapply(pkgs, function(x) "igraph" %in% x))
