#' SHAP Interaction Plot
#'
#' Plots a beeswarm plot for each feature pair. Diagonals represent the main effects,
#' while off-diagonals show interactions (multiplied by two due to symmetry).
#' The colors on the beeswarm plots represent min-max scaled feature values.
#' Non-numeric features are transformed to numeric by calling \code{data.matrix()} first.
#' The features are sorted in decreasing order of usual SHAP importance.
#'
#' @param object An object of class "shapviz" containing element \code{S_inter}.
#' @param kind Set to "no" to simply return the matrix of average absolute SHAP
#' interactions. The default is "beeswarm".
#' @param max_display Maximum number of features (with highest SHAP importance) to plot.
#' Set to \code{Inf} to show all features. Has no effect if \code{kind = "no"}.
#' @param alpha Transparency of the beeswarm dots. Defaults to 0.3.
#' @param bee_width Relative width of the beeswarms (only used if beeswarm shown).
#' @param bee_adjust Relative bandwidth adjustment factor used in
#' estimating the density of the beeswarms (only used if beeswarm shown).
#' @param viridis_args List of viridis color scale arguments used to control the
#' coloring of the beeswarm plot, see \code{?ggplot2::scale_color_viridis_c()}.
#' The default points to the global option \code{shapviz.viridis_args}, which
#' corresponds to \code{list(begin = 0.25, end = 0.85, option = "inferno")}.
#' These values are passed to \code{ggplot2::scale_color_viridis_c()}.
#' For example, to switch to a standard viridis scale, you can either change the default
#' with \code{options(shapviz.viridis_args = NULL)} or set \code{viridis_args = NULL}.
#' @param color_bar_title Title of color bar of the beeswarm plot.
#' Set to \code{NULL} to hide the color bar altogether.
#' @param ... Arguments passed to \code{geom_point()}.
#' For instance, passing \code{size = 1} will produce smaller dots.
#' @return A "ggplot" object, or - if \code{kind = "no"} - a named numeric matrix
#' of average absolute SHAP interactions sorted by the average absolute SHAP values.
#' @export
#' @examples
#' dtrain <- xgboost::xgb.DMatrix(data.matrix(iris[, -1]), label = iris[, 1])
#' fit <- xgboost::xgb.train(data = dtrain, nrounds = 50, nthread = 1)
#' x <- shapviz(fit, X_pred = dtrain, X = iris, interactions = TRUE)
#' sv_interaction(x)
#' sv_interaction(x, max_display = 2, size = 3, alpha = 0.1)
#' sv_interaction(x, kind = "no")
sv_interaction <- function(object, ...) {
  UseMethod("sv_interaction")
}

#' @describeIn sv_interaction Default method.
#' @export
sv_interaction.default <- function(object, ...) {
  stop("No default method available.")
}

#' @describeIn sv_interaction SHAP interaction plot for an object of class "shapviz".
#' @export
sv_interaction.shapviz <- function(object, kind = c("beeswarm", "no"),
                                   max_display = 7L, alpha = 0.3,
                                   bee_width = 0.3, bee_adjust = 0.5,
                                   viridis_args = getOption("shapviz.viridis_args"),
                                   color_bar_title = "Row feature value", ...) {
  kind <- match.arg(kind)
  S_inter <- get_shap_interactions(object)
  if (is.null(S_inter)) {
    stop("No SHAP interaction values available.")
  }
  ord <- names(.get_imp(get_shap_values(object)))

  if (kind == "no") {
    mat <- apply(abs(S_inter), 2:3, mean)[ord, ord]
    off_diag <- row(mat) != col(mat)
    mat[off_diag] <- mat[off_diag] * 2  # compensate symmetry
    return(mat)
  }

  if (ncol(S_inter) > max_display) {
    ord <- ord[seq_len(max_display)]
  }

  # Prepare data.frame for beeswarm
  S_inter <- S_inter[, ord, ord, drop = FALSE]
  X <- .scale_X(get_feature_values(object)[ord])
  X_long <- as.data.frame.table(X)
  df <- transform(
    as.data.frame.table(S_inter, responseName = "value"),
    Variable1 = factor(Var2, levels = ord),
    Variable2 = factor(Var3, levels = ord),
    color = X_long$Freq  #  Correctly recycled along the third dimension of S_inter
  )

  # Compensate symmetry
  mask <- df[["Variable1"]] != df[["Variable2"]]
  df[mask, "value"] <- 2 * df[mask, "value"]

  ggplot(df, aes(x = value, y = "1")) +
    geom_vline(xintercept = 0, color = "darkgray") +
    geom_point(
      aes(color = color),
      position = position_bee(width = bee_width, adjust = bee_adjust),
      alpha = alpha,
      ...
    ) +
    facet_grid(Variable1 ~ Variable2, switch = "y") +
    labs(x = "SHAP value", y = element_blank(), color = color_bar_title) +
    .get_color_scale(
      viridis_args = viridis_args,
      bar = !is.null(color_bar_title),
      ncol = length(unique(X_long$Freq))
    ) +
    theme(
      panel.spacing = unit(0.2, "lines"),
      axis.ticks.y = element_blank(),
      axis.text.y = element_blank()
    )
}
