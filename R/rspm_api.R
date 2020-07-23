#' @rdname rspm_api
#'
#' @name rspm_api
#'
#' @title API to interact with RStudio package manager
#'
#' @description These functions provide an interface with the RStudio
#'     package manager API as functions with the prefix 'rspm'.
#'     URL: https://packagemanager.rstudio.com/__api__/swagger/index.html to
#'     the RSPM API swagger page.
NULL


#' @importFrom httr accept stop_for_status content GET
.rspm_get_query <-
    function(query)
{
    response <- GET(
        query,
        accept("application/json")
    )
    ## TODO: This fails when response is 400
    stop_for_status(response)
    content(response)
}


.rspm_get <-
    function(path, api="https://packagemanager.rstudio.com/__api__",
             path_root="/repos")
{
    query <- sprintf("%s%s%s", api, path_root, path)
    .rspm_get_query(query)
}


#' @rdname rspm_api
#'
#' @description Get available repos from RStudio Package Manager.
#'
#' @param type character(1) value can only be 'R' in present API.
#'
#' @return
#'
#' @examples
#'
#' @importFrom dplyr bind_rows
#'
#' @export
rspm_get_repos <-
    function(type = "R")
{
    ## validity
    stopifnot(
        type == "R",
        is.character(type)
    )
    ## query
    path = paste0("?type=", type)
    res <- .rspm_get(path = path)
    ## return value as tibble
    bind_rows(res)
}


#' @rdname rspm_api
#'
#' @description
#'
#' @param id character(1)
#'
#' @param limit character(1)
#'
#' @param page character(1)
#'
#' @param name character(1)
#'
#' @param name_search character(1)
#'
#' @return
#'
#' @examples
#' 
#' @export
rspm_get_packages <-
    function(id = 1L, limit = 10L, page, name, name_search)
{
    ## validity check "id" is required
    if( id < 1L || id > 2L) {
        stop("'id' can be only be either 1 or 2, ",
             "run 'rspm_get_repos()' for details")
    }
    
    ## Stitch query
    path <- paste0("/", id, "/packages?")
    if( !missing(limit) && !is.na) {
        path <- paste0(path, "_limit=", as.integer(limit), "&")
    }
    if( !missing(page) && !is.na(page)) {
        path <- paste0(path, "_page=", as.integer(page), "&")
    }
    if( !missing(name) && .is_character(name)) {
        path <- paste0(path, "name=", name, "&")
    }
    if( !missing(name_search) && .is_character(name_search)) {
        path <- paste0(path, "name_search=", name_search)
    }

    ## Query
    response <- .rspm_get(path = path)

    ## Remove quotes for better display
    tbl <- bind_rows(response)
    tbl[tbl == ""] <- NA
    tbl
}


#' @rdname rspm_api
#'
#' @description Fetch system requirements by package
#'
#' @param character(1) package_name
#'
#' @return
#'
#' @examples
#'
#' @export
rspm_get_package_sysreqs <-
    function(package_name, id = 1L)
{
    ## Validity checks
    if( missing(package_name) || !.is_character(package_name)) {
        stop("'package_name' needs a character vector containing a",
             " CRAN package name")
    }

    ## query
    path <- paste0("/", id, "/sysreqs?all=false&pkgname=", package_name)

    ## response
    response <- .rspm_get(path = path)
    ## clean response
    reqs <- unique(
        unname(unlist(response)[
            grepl("packages", names(unlist(response)))
        ])
    )
    tibble(sysreqs = reqs)
}


#' @rdname
#'
#' @description
#'
#' @return
#'
#' @examples
#'
#' @importFrom dplyr `%>%` mutate
#' @importFrom tidyr unnest pivot_wider
#' @export
rspm_get_sysreqs <-
    function(id = 1L)
{
    path <- paste0("/", id, "/sysreqs?all=true&pkgname=")
    response <- .rspm_get(path = path)

    ## TODO: fix display
    bind_rows(response) %>%
        mutate(
            label = names(requirements),
            label_name = lapply(
                requirements, function(elt) names(elt[[1]])
            ),
            requirements = unname(
                lapply(requirements, unlist, use.names = FALSE)
            )
        ) %>%
        unnest(c(requirements, label_name)) %>%
        pivot_wider(
            id_cols = "name",
            names_from = "label",
            values_from = "requirements"
        ) %>%

    unnest(c(packages, install_scripts, post_install), keep_empty = TRUE) %>%
    unnest(pre_install, keep_empty = TRUE)
}


#' @rdname rspm_api
#'
#' @description Get the status of the Rstudio package manager
#'
#' @return tibble status of RSPM
#'
#' @examples
#'
#' @export
rspm_status <-
    function()
{
    response <- .rspm_get(path = "", path_root = "/status")
    ## Display version
    message("version:", response$version, "\n",
        "build_date:", response$build_date, "\n")
    ## return distros
    tbl <- bind_rows(response$distros)
    tbl[tbl == ""] <- NA
    tbl
}


## Utility function
.is_character <-
    function(x, na_ok = FALSE, zchar = FALSE)
{
    is.character(x) &&
        (na_ok || all(!is.na(x))) &&
        (zchar || all(nzchar(x)))
}
