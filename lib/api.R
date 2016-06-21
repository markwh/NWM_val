# api.R
# Mark Hagemann
# 6/16/2016
# Functions for accessing the national water model forecast API
# Following https://cran.r-project.org/web/packages/httr/vignettes/api-packages.html
# Also hijacks code from rnoaa package.


# Convention Helper functions ---------------------------------------------

#' @importFrom httr GET timeout
#' @importFrom httr timeout
nwm_get <- function(service, arglist = list(), check = TRUE) {
  
  dots <- arglist[!sapply(arglist, is.null)]
  url0 <- paste0('https://apps.hydroshare.org/apps/nwm-data-explorer/api/GetWaterML/',
                 service)
  append <- nwm_makeArgs(dots)
  
  url1 <- paste(url0, append, sep = "?")
  cat(url1)
  res <- GET(url1, timeout(seconds = getOption("timeout")))
  
  if (!check)
    return(res)
  
  tt <- nwm_check(res)
  out <- tt # was envir_makeDF(tt) but here don't want data.frames.
  
  attr(out, "url") <- res$url
  out
}

#' @importFrom httr content stop_for_status
nwm_check <- function(x) {
  if (!x$status_code == 200) {
    stnames <- names(content(x))
    if (!is.null(stnames)) {
      if ("developerMessage" %in% stnames | "message" %in%
          stnames) {
        stop(sprintf("Error: (%s) - %s", x$status_code,
                     nwm_compact(list(content(x)$developerMessage,
                                        content(x)$message))))
      }
      else {
        stop(sprintf("Error: (%s)", x$status_code))
      }
    }
    else {
      stop_for_status(x)
    }
  }
  else {
    stopifnot(x$headers$`content-type` == "application/json")
    res <- content(x, as = "text", encoding = "UTF-8")
    out <- jsonlite::fromJSON(res, simplifyVector = FALSE)
    if (!"results" %in% names(out)) {
      if (length(out) == 0) {
        warning("Sorry, no data found")
      }
    }
    else {
      if (class(try(out$results, silent = TRUE)) == "try-error" |
          is.null(try(out$results, silent = TRUE)))
        warning("Sorry, no data found")
    }
    return(out)
  }
}

nwm_parse <- function(req) {
  text <- content(req, as = "text")
  if (identical(text, "")) stop("No output to parse", call. = FALSE)
  jsonlite::fromJSON(text, simplifyVector = FALSE)
}

#' @importFrom magrittr "%>%"
nwm_makeArgs <- function(arglist) {
  if (length(arglist) == 0)
    return(NULL)
  
  # names(arglist) = toupper(names(arglist))
  arglens <- vapply(arglist, length, numeric(1))
  
  # stopifnot(all(sapply(arglist, is.character)))
  # stopifnot(all(sapply(arglens, `<`, 3)))
  
  # separate operators
  al2 <- lapply(arglist, paste, collapse = "&")
  
  urlArgs <- Map(paste, names(al2), unlist(al2), sep = "=") %>%
    unlist() %>%
    # c("", .) %>%
    paste(collapse = "&") %>%
    URLencode()
  
  urlArgs
}
