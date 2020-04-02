#' Makes All Databases within the MADWorld
#'
#' The key function of the MADworld package. When run with defaults,
#' it will download all data from all stable MADworld packages. This
#' takes a very long time, so consider whether you really want to do
#' it!  Downloads from all packages are saved within subfolders of the
#' 'cache' directory; while it is possible to not use a cache
#' directory we strongly advise against it. Note that this function
#' can be used to update all MAD packages (see \code{cache} below).
#' 
#' @param cache Specify a directory/folder within which MAD package
#'     will be cached in subfolders with their names. Existing folders
#'     and files will be left untouched, such that you can update to
#'     incorporate new datasets that have been added to the
#'     MADworld. You must either specify an location for download
#'     (which will be created if it does not exist), or specify
#'     \code{NULL} if you do not wish to cache. The download process
#'     takes many hours; we *STRONGLY* advise you to specify a cache
#'     location.
#' @param packages Character vector of packages to be searched for
#'     trait data. Specify "stable" to download all stable packages
#'     (DEFAULT), "prototype" to download all prototype packages, and
#'     "world" to download all packages.
#' @param delay How many seconds to wait between downloading and
#'     processing each dataset (default: 5). This delay may seem
#'     large, but if you specify a \code{cache} (see above) you only
#'     need do it once, and specifying a large delay ensures you don't
#'     over-stretch servers. Keeping servers happy is good for you
#'     (they won't reject you!) and good for them (they can help
#'     everyone).
#' @return \code{list} containing all the MADworld package data
#'     objects loaded into memory
#' @author Will Pearse
#' @examples
#' \dontrun{
#' # Download all stable packages
#' MADworld <- MADworld(cache="~/MADworld/")
#' # Extract MADtraits and look at how much data you downloaded
#' (MADtraits <- MADworld$MADtraits)
#' }
MADworld <- function(cache, packages="stable", delay=5){
    # Choose packages to download
    packages <- .mad.packages(packages)
    
    # Setup cache and sub-directories within cache
    if(!is.na(cache)){
        if(file.exists(cache))
            stop(cache, "is an existing *file*, not *directory*")
        if(!dir.exists(cache))
            dir.create(cache)
        if(substr(cache, nchar(cache), nchar(cache)) == "/")
            cache <- substr(cache, 0, nchar(cache)-1)
        for(i in seq_along(packages))
            if(!dir.exists(file.path(cache, packages)))
                dir.create(file.path(cache, packages))
    } else {
        warning("You chose not to store MADworld's downloads on disk")
    }
    
    # Do work and return
    cat("Downloading/loading MADworld\n")
    output <- vector("list", length(packages))
    for(i in seq_along(packages)){
        cat("\t", packages[i], " ...\n")
        func <- eval(as.name(packages[i]))
        output[[i]] <- func(cache=file.path(cache, packages[i]), delay=delay)
    }
    cat("Download complete!\n")
    names(output) <- packages
    return(output)
}
