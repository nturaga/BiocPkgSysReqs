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
    function(package_name)
{
    ## validity checks
    if(missing(package_name) || !.is_character(package_name)) {
        stop("the argument 'package_name' takes a character vector",
             "of Bioconductor package names.")
    }
    ## Get bioc packages
    biocsoft <- available.packages(
        repos = BiocManager::repositories()[["BioCsoft"]]
    )

    ## Get database for package_dependencies
    db <- available.packages(
        repos = BiocManager::repositories()
    )

    ## Get package_dependencies of all bioc pkgs
    pkgs <- tools::package_dependencies(
                       rownames(biocsoft),
                       db=db,
                       which=c("Depends", "Suggests")
                   )
    ## Get all dependencies of packages
    all_deps <- unname(
        unlist(pkgs[package_name])
    )

    ## Get only cran dependencies
    cran_deps <- all_deps[! all_deps %in% biocsoft]

    ## Make tibble with resuls
    result <- tibble(sysreqs = character())
    for (cran_pkg in cran_deps) {
        tbl <- rspm_get_package_sysreqs(package_name = cran_pkg)
        result <- bind_rows(result, tbl)
    }

    result
}
# which(sapply(pkgs, function(x) "igraph" %in% x))
