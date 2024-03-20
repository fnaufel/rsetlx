
#' Add setlx engine to knitr.
#'
#' See https://randoom.org/Software/SetlX/
#'
#' Invoke the setlx engine like so:
#'
#' ````
#' ```{setlx}
#' ...
#' ```
#' ````
#'
#' @param libname Not used.
#' @param pkgname Not used.
#'
#' @return Nothing (invisible)
#' @export
#'
#' @author fnaufel
#' @importFrom knitr knit_engines engine_output
.onAttach <- function(libname, pkgname) {

  options(setlx_exec_name = 'setlX')

  knitr::knit_engines$set(

    setlx = function(options) {

      if (options$eval) {

        # Write code to temp file
        filename <- tempfile()
        writeLines(options$code, filename)

        # Run with setlx
        out  <- system2(
          getOption('setlx_exec_name'),
          filename,
          stdout = TRUE,
          stderr = TRUE
        )
      } else {
        out <- ''
      }

      code_str <- paste(options$code, collapse = '\n')
      knitr::engine_output(options, code_str, out)

    }

  )

  packageStartupMessage(
    'Enabling setlx knitr engine.\n',
    'Use ```{setlx} in code chunk.\n'
  )

  invisible()

}
