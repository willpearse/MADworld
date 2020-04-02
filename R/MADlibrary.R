#' Installs and then loads all MADWorld packages
#'
#' When run with defaults, it will load (and install if necessary) all
#' MADworld packages. This is used to show MADworld status at package
#' load.
#' 
#' @param packages Which packages to be loaded or installed. One of
#'     "stable" (DEFAULT) for only stable packages, "prototype" for
#'     only prototype packages, and "world" for all packages
#' @param install Whether to install packages that can't be loaded
#'     (\code{TRUE} by default)
#' @param force.install Whether to (re-)install packages regardless
#'     of whether they can or can't be loaded (\code{FALSE} by
#'     default)
#' @author Will Pearse
#' @examples
#' \dontrun{
#' # What you saw when you loaded MADworld
#' MADlibrary("stable", install=FALSE)
#' # Install all MADworld packages
#' MADlibrary("world")
#' }
#' @importFrom cli rule
#' @importFrom stringi stri_pad_right
#' @importFrom crayon bold green
#' @importFrom utils install.packages packageVersion
MADlibrary <- function(packages=c("stable","prototype","world"), install=TRUE, force.install=FALSE){
    # Get package lists
    packages <- .mad.packages(match.arg(packages))
    missing.packages <- setdiff(.mad.packages("world"), packages)
    
    # Install packages (if necessary or forced)
    if(force.install){
        lapply(packages, install.packages)
    } else {
        if(install)
            lapply(Filter(Negate(require), packages), install.packages)
    }
    
    # Load and print pretty info
    rule(left=crayon::bold("MADworld"), right=paste("version", packageVersion("MADworld")))
    for(i in seq_along(packages)){
        if(require(packages[i])){
            cat(crayon::green(stri_pad_right(packages[i], 15)), "\n")
            
        } else missing.packages <- append(missing.packages, packages[i])
    }
    if(length(missing.packages) > 0){
        rule(left=("Cannot load"))
        cat("\t", paste(crayon::red(missing.packages), sep=", "))
    }
}
