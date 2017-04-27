#' data.frame-first formula-second method for \code{\link[xgboost]{xgboost}}
#'
#' This function passes a data.frame, formula, and additional arguments to
#' \code{\link[xgboost]{xgboost}}.
#'
#' @seealso \code{\link[xgboost]{xgboost}}
#'
#' @inheritParams twidlr_defaults
#' @export
#'
#' @examples
#' xgboost(mtcars, hp ~ ., nrounds = 10)
#'
#' # Help page for function being twiddled
#' ?xgboost::xgboost
xgboost <- function(data, formula, ...) {
  check_pkg("xgboost")
  UseMethod("xgboost")
}

#' @export
xgboost.default <- function(data, formula, ...) {
  xgboost.data.frame(as.data.frame(data), formula, ...)
}

#' @export
xgboost.data.frame <- function(data, formula, ...) {
  dat <- model_as_xy(data, formula)
  object <- xgboost::xgboost(data = dat$x, label = dat$y, ...)
  attr(object, "formula") <- formula
  object
}

#' @rdname xgboost
#' @export predict.xgb.Booster
predict.xgb.Booster <- function(object, data, ...) {
  if (hasArg(newdata)) {
    return (xgboost:::predict.xgb.Booster(object, newdata = newdata, ...))
  }

  data <- model_as_xy(data, attr(object, "formula"))$x
  xgboost:::predict.xgb.Booster(object, newdata = data, ...)
}