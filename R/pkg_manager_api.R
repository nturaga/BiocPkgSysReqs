#' @importFrom httr accept stop_for_status content GET
.rspm_get_query <- function(url, query) {
    response <- GET(
        url = url,
        query = query,
        accept("application/json")
    )
    stop_for_status(response)
    content(response)
}


.rspm_get <- function(query = list(),
                      api="https://packagemanager.rstudio.com/__api__",
                      path_root="/repos") {
    url <- sprintf("%s%s", api, path_root)
    .rspm_get_query(url, query)
}


#' @details
#'
#' @param type `character(1)` value can only be 'R' in present API.
#'
#' @importFrom dplyr bind_rows
#' @export
rspm_get_repos <- function(type="R") {
    ## validity
    stopifnot(
        type == "R",
        is.character(type)
    )
    ## query
    query <- list(type = type)
    res <- .rspm_get(query = query)
    ## return value as tibble
    bind_rows(res)
}


#'
#' @export
rspm_get_packages <-
    function(id, limit, page, name, name_search)
{
    ## TODO: validity checks
    if(is.numeric(id) || is.numeric(limit) || is.numeric(page)) {
        stop("the arguments 'id', 'limit', 'page' need to be 'numeric'.")
    }


    ## Stitch query
    path_root <- sprintf("/repos/%s/packages?",id)
    query = list()
    browser()
    if(limit)
        query[["limit"]] = limit

    if(page)
        query[["page"]] = page

    if(.is_character(name))
        query[["name"]] = name

    if(.is_character(name_search))
        query[["name_search"]] = name_search

    ## Query
    response <- .rspm_get(query = query, path_root = path_root)
    bind_rows(response)
}


# https://packagemanager.rstudio.com/__api__/repos/2/packages/igraph/sysreqs
#'
#' @export
rspm_get_package_sysreqs <-
    function(id, package_name, distribution, release)
{
    path_root <- sprintf("/repos/%s/packages?",id)
    query = list()
    browser()
    if(limit)
        query[["limit"]] = limit

    if(page)
        query[["page"]] = page

    if(.is_character(name))
        query[["name"]] = name

    if(.is_character(name_search))
        query[["name_search"]] = name_search

    ## Query
    response <- .rspm_get(query = query, path_root = path_root)
    bind_rows(response)
}



.is_character <-
    function(x, na.ok = FALSE, zchar = FALSE)
{
    is.character(x) &&
        (na.ok || all(!is.na(x))) &&
        (zchar || all(nzchar(x)))
}

.is_scalar_character <- function(x, na.ok = FALSE, zchar = FALSE)
    length(x) == 1L && .is_character(x, na.ok, zchar)
