########## Defines the MADworld packages! ##########
.mad.packages <- function(packages){
    stable <- c("MADtraits","MADcomm")
    prototype <- c("MADneon","MADpandemic")
    
    if(length(packages) == 1){
        if(packages=="stable"){
            packages <- stable
        } else {
            if(packages=="prototype")
                packages <- prototype
        }
    }
    if(!all(packages %in% c(stable, prototype)))
        stop(packages, "contains unknown MADworld packages")
}
