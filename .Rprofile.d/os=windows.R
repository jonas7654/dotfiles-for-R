#' Tweaks when running R for MS Windows via Wine on Linux
#'
#' Options that are set:
#' * `download.file.method`
#' * `useFancyQuotes`
#'
#' Environment variables that are set:
#' * `LC_TIME`
#' * `LC_MONETARY`
#' * `BINPREF`
#'
#' @author Henrik Bengtsson

## Wine on Linux tweaks
if (startup::sysinfo()$wine) {
  options(download.file.method = "libcurl")
  Sys.setenv(LC_TIME = "C")
  Sys.setenv(LC_MONETARY = "C")
  options(useFancyQuotes = FALSE)
}

## Use new gcc-4.9.3 toolchain in R (>= 3.3.0) for Windows
## (source: Bioconductor https://goo.gl/MMbGkg)
## NOTE: This only works if `--no-init-file` is _not_ used.
if (getRversion() >= "3.3.0" && !nzchar(Sys.getenv("BINPREF"))) {
  local({
    ## Find out how R was built
    ## https://twitter.com/opencpu/status/717411491364798464
    Rbin <- file.path(R.home("bin"), "R")
    cby <- suppressWarnings(system2(Rbin, "--vanilla CMD config COMPILED_BY",
                                    stdout = TRUE, stderr = TRUE))
    if (any(cby %in% c("gcc-4.9.3"))) {
      path <- "C:/Rtools/mingw_$(WIN)/bin/"
      message(sprintf("NOTE: Setting BINPREF=%s (via .Rprofile)", path))
      Sys.setenv(BINPREF = path)
    }
  })
}
