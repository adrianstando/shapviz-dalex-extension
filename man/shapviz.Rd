% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/shapviz.R
\name{shapviz}
\alias{shapviz}
\alias{shapviz.default}
\alias{shapviz.matrix}
\alias{shapviz.xgb.Booster}
\alias{shapviz.lgb.Booster}
\alias{shapviz.explain}
\alias{shapviz.treeshap}
\alias{shapviz.predict_parts}
\alias{shapviz.shapr}
\alias{shapviz.kernelshap}
\alias{shapviz.H2ORegressionModel}
\alias{shapviz.H2OBinomialModel}
\alias{shapviz.H2OModel}
\title{Initialize "shapviz" Object}
\usage{
shapviz(object, ...)

\method{shapviz}{default}(object, ...)

\method{shapviz}{matrix}(object, X, baseline = 0, collapse = NULL, S_inter = NULL, ...)

\method{shapviz}{xgb.Booster}(
  object,
  X_pred,
  X = X_pred,
  which_class = NULL,
  collapse = NULL,
  interactions = FALSE,
  ...
)

\method{shapviz}{lgb.Booster}(object, X_pred, X = X_pred, which_class = NULL, collapse = NULL, ...)

\method{shapviz}{explain}(object, X, baseline = 0, collapse = NULL, ...)

\method{shapviz}{treeshap}(
  object,
  X = object[["observations"]],
  baseline = 0,
  collapse = NULL,
  ...
)

\method{shapviz}{predict_parts}(object, X = object[["X"]], collapse = NULL, ...)

\method{shapviz}{shapr}(object, X = object[["x_test"]], collapse = NULL, ...)

\method{shapviz}{kernelshap}(object, X = object[["X"]], which_class = NULL, collapse = NULL, ...)

\method{shapviz}{H2ORegressionModel}(object, X_pred, X = as.data.frame(X_pred), collapse = NULL, ...)

\method{shapviz}{H2OBinomialModel}(object, X_pred, X = as.data.frame(X_pred), collapse = NULL, ...)

\method{shapviz}{H2OModel}(object, X_pred, X = as.data.frame(X_pred), collapse = NULL, ...)
}
\arguments{
\item{object}{For XGBoost, LightGBM, and H2O, this is the fitted model used to
calculate SHAP values from \code{X_pred}.
In the other cases, it is the object containing the SHAP values.}

\item{...}{Parameters passed to other methods (currently only used by
the \code{predict} functions of XGBoost, LightGBM, and H2O).}

\item{X}{Matrix or data.frame of feature values used for visualization.
It must contain at least the same column names as the SHAP matrix represented by
\code{object}/\code{X_pred} (after optionally collapsing some of the SHAP columns).}

\item{baseline}{Optional baseline value, representing the average response at the
scale of the SHAP values. It will be used for plot methods that explain single
predictions.}

\item{collapse}{A named list of character vectors. Each vector specifies a group of
column names in the SHAP matrix that should be collapsed to a single column by summation.
The name of the new column equals the name of the vector in \code{collapse}.}

\item{S_inter}{Optional 3D array of SHAP interaction values.
If \code{object} has shape n x p, then \code{S_inter} needs to be of shape n x p x p.
Summation over the second (or third) dimension should yield the usual SHAP values.
Furthermore, dimensions 2 and 3 are symmetric. Default is \code{NULL}.}

\item{X_pred}{Data set as expected by the \code{predict} function of
XGBoost, LightGBM, or H2O. For XGBoost, a matrix or \code{xgb.DMatrix},
for LightGBM a matrix, and for H2O a \code{data.frame} or an \code{H2OFrame}.
Only used for XGBoost, LightGBM, or H2O objects.}

\item{which_class}{In case of a multiclass or multioutput setting,
which class/output (>= 1) to explain. Currently relevant for XGBoost, LightGBM,
and kernelshap.}

\item{interactions}{Should SHAP interactions be calculated (default is \code{FALSE})?
Only available for XGBoost.}
}
\value{
An object of class "shapviz" with the following three elements:
\itemize{
\item \code{S}: A numeric matrix of SHAP values.
\item \code{X}: A \code{data.frame} containing the feature values corresponding to \code{S}.
\item \code{baseline}: Baseline value, representing the average prediction at the scale of the SHAP values.
\item \code{S_inter}: A numeric array of SHAP interaction values (or \code{NULL}).
}
}
\description{
This function creates an object of class "shapviz" from one of the following inputs:
\itemize{
\item Matrix with SHAP values
\item XGBoost model
\item LightGBM model
\item "explain" object from the package "fastshap"
\item H2O model (tree-based regression or binary classification model)
\item "shapr" object from the package "shapr"
\item The result of calling \code{treeshap()} from the "treeshap" package
\item The result of calling \code{predict_parts()} from the "DALEX" package
\item "kernelshap" object from the "kernelshap" package
}
The "shapviz" vignette explains how to use each of them.
Together with the main input, a data set \code{X} of feature values is required,
which is used only for visualization. It can therefore contain character or factor
variables, even if the SHAP values were calculated from a purely numerical feature
matrix. In addition, to improve visualization, it can sometimes be useful to truncate
gross outliers, logarithmize certain columns, or replace missing values with an
explicit value. SHAP values of dummy variables can be combined using the convenient
\code{collapse} argument.
}
\section{Methods (by class)}{
\itemize{
\item \code{shapviz(default)}: Default method to initialize a "shapviz" object.

\item \code{shapviz(matrix)}: Creates a "shapviz" object from a matrix of SHAP values.

\item \code{shapviz(xgb.Booster)}: Creates a "shapviz" object from an XGBoost model.

\item \code{shapviz(lgb.Booster)}: Creates a "shapviz" object from a LightGBM model.

\item \code{shapviz(explain)}: Creates a "shapviz" object from fastshap's "explain()" method.

\item \code{shapviz(treeshap)}: Creates a "shapviz" object from treeshap's "treeshap()" method.

\item \code{shapviz(predict_parts)}: Creates a "shapviz" object from DALEX's "predict_parts()" method.

\item \code{shapviz(shapr)}: Creates a "shapviz" object from shapr's "explain()" method.

\item \code{shapviz(kernelshap)}: Creates a "shapviz" object from kernelshap's "kernelshap()" method.

\item \code{shapviz(H2ORegressionModel)}: Creates a "shapviz" object from a (tree-based) H2O regression model.

\item \code{shapviz(H2OBinomialModel)}: Creates a "shapviz" object from a (tree-based) H2O binary classification model.

\item \code{shapviz(H2OModel)}: Creates a "shapviz" object from a (tree-based) H2O model (base class).

}}
\examples{
S <- matrix(c(1, -1, -1, 1), ncol = 2, dimnames = list(NULL, c("x", "y")))
X <- data.frame(x = c("a", "b"), y = c(100, 10))
shapviz(S, X, baseline = 4)

X_pred <- data.matrix(iris[, -1])
dtrain <- xgboost::xgb.DMatrix(X_pred, label = iris[, 1])
fit <- xgboost::xgb.train(data = dtrain, nrounds = 50, nthread = 1)

# Will use numeric matrix "X_pred" as feature matrix
x <- shapviz(fit, X_pred = X_pred)
x
sv_dependence(x, "Species")

# Will use original values as feature matrix
x <- shapviz(fit, X_pred = X_pred, X = iris)
sv_dependence(x, "Species")

# "X_pred" can also be passed as xgb.DMatrix, but only if X is passed as well!
x <- shapviz(fit, X_pred = dtrain, X = iris)

# Similarly with LightGBM
if (requireNamespace("lightgbm", quietly = TRUE)) {
  fit <- lightgbm::lgb.train(
    params = list(objective = "regression"),
    data = lightgbm::lgb.Dataset(X_pred, label = iris[, 1]),
    nrounds = 50,
    verbose = -2
  )
  x <- shapviz(fit, X_pred = X_pred)
}

# In multiclass setting, we need to specify which_class (integer starting at 1)
params <- list(objective = "multi:softprob", num_class = 3)
X_pred <- data.matrix(iris[, -5])
dtrain <- xgboost::xgb.DMatrix(X_pred, label = as.integer(iris[, 5]) - 1L)
fit <- xgboost::xgb.train(params = params, data = dtrain, nrounds = 50)
x <- shapviz(fit, X_pred = X_pred, which_class = 3)

# What if we would have one-hot-encoded values and want to explain the original column?
X_pred <- stats::model.matrix(~ . -1, iris[, -1])
dtrain <- xgboost::xgb.DMatrix(X_pred, label = as.integer(iris[, 1]))
fit <- xgboost::xgb.train(data = dtrain, nrounds = 50)
x <- shapviz(
  fit,
  X_pred = X_pred,
  X = iris,
  collapse = list(Species = c("Speciessetosa", "Speciesversicolor", "Speciesvirginica"))
)
x
}
\seealso{
\code{\link{sv_importance}}, \code{\link{sv_dependence}}, \code{\link{sv_interaction}},
\code{\link{sv_waterfall}}, \code{\link{sv_force}}, \code{\link{collapse_shap}}
}
