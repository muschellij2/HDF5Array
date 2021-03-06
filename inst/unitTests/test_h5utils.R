test_get_h5dimnames_set_h5dimnames <- function()
{
    h5file <- tempfile(fileext=".h5")
    A <- h5write(array(1:60, 5:3), h5file, "A")
    A2 <- h5write(letters[1:4], h5file, "A2")
    A3 <- h5write(LETTERS[1:3], h5file, "A3")
    set_h5dimnames(h5file, "A", c(NA, "A2", NA), dry.run=TRUE)
    set_h5dimnames(h5file, "A", c(NA, "A2", "A3"))
    target <- c(NA, "/A2", "/A3")
    current <- get_h5dimnames(h5file, "A")
    checkIdentical(target, current)
}

test_h5readDimnames_h5writeDimnames <- function()
{
    h5file <- tempfile(fileext=".h5")
    h5createFile(h5file)
    h5createGroup(h5file, "stuff")
    Aname <- "stuff/A"
    A <- writeHDF5Array(array(1:24, 4:1), h5file, Aname)
    Bname <- "stuff/B"
    B <- writeHDF5Array(array(101:124, 2:4), h5file, Bname)
    Cname <- "stuff/C"
    C <- writeHDF5Array(matrix(201:206, ncol=2), h5file, Cname)

    ## Write dimnames for 'A'.
    Adimnames <- list(letters[1:4], NULL, 11:12, NULL)
    h5writeDimnames(Adimnames, h5file, Aname)
    current <- h5readDimnames(h5file, Aname)
    checkIdentical(Adimnames, current)

    ## Write dimnames (with dimlabels) for 'B'.
    Bdimnames <- list(x=letters[1:2], y=NULL, LETTERS[1:4])
    h5dimnames <- c("X", "Y", "Z")
    h5writeDimnames(Bdimnames, h5file, Bname, h5dimnames=h5dimnames)
    current <- h5readDimnames(h5file, Bname)
    checkIdentical(Bdimnames, current)

    ## Write dimnames for 'C'.
    Cdimnames <- list(NULL, NULL)

    ## Does not actually write anything to the HDF5 file.
    h5writeDimnames(Cdimnames, h5file, Cname)
    current <- h5readDimnames(h5file, Cname)
    checkIdentical(NULL, current)

    names(Cdimnames) <- c("", "")
    ## Does not actually write anything to the HDF5 file.
    h5writeDimnames(Cdimnames, h5file, Cname)
    current <- h5readDimnames(h5file, Cname)
    checkIdentical(NULL, current)

    names(Cdimnames)[[1]] <- "x"
    h5writeDimnames(Cdimnames, h5file, Cname, group="more stuff")
    current <- h5readDimnames(h5file, Cname)
    checkIdentical(Cdimnames, current)
}

