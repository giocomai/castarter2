#' Set folder for storing project files
#'
#' Your project folder can be anywhwere on your file system. Considering that
#' this is where possibly a very large number of html files will be downloaded,
#' it is usually preferrable to choose a location that is not included in live
#' backups. These settings determine the names given to these hierarchical
#' folders: `website` folder will be under `project` folder which will be under
#' the `base_folder`.
#'
#' @param base_folder Defaults to NULL, can be set once per session with
#'   [cas_set_options()]. A path to a location used for storing html and other
#'   project files. If the folder does not exist, it will be created. If not
#'   given, and not previously set as environment variable, defaults to
#'   `castarter_data`.
#' @param db_folder Defaults to NULL. can be set once per session with
#'   [cas_set_options()] or [cas_set_db_folder()]. A path to a location used for
#'   storing the database. If not given, and not previously set as environment
#'   variable, defaults to `castarter_data`.
#' @param project Defaults to NULL. Project name, can be set once per session
#'   with [cas_set_options()]. This will be used as first level folder and may
#'   be used elsewhere to describe the dataset.
#' @param website Defaults to NULL. Website name, can be set once per session
#'   with [cas_set_options()]. This will be used as a second level folder and
#'   may be used elsewhere to describe the dataset.
#'
#' @family settings
#'
#' @return A list object with the newly set (or previously set if left to NULL)
#'   options.
#' @export
#' @examples
#' cas_set_options(base_folder = fs::path(fs::path_temp(), "castarter_data"))
#' cas_options_list <- cas_get_options()
#' cas_options_list
cas_set_options <- function(base_folder = NULL,
                            db_folder = NULL,
                            project = NULL,
                            website = NULL) {
  if (is.null(base_folder)) {
    base_folder <- Sys.getenv("castarter_base_folder")
  } else {
    Sys.setenv(castarter_base_folder = base_folder)
  }
  if (base_folder == "") {
    base_folder <- fs::path("castarter_data")
  }

  if (is.null(db_folder)) {
    db_folder <- Sys.getenv("castarter_database_folder")
  } else {
    Sys.setenv(castarter_database_folder = db_folder)
  }
  if (db_folder == "") {
    db_folder <- fs::path("castarter_data")
  }

  if (is.null(project)) {
    project <- Sys.getenv("castarter_project")
  } else {
    Sys.setenv(castarter_project = project)
  }

  if (is.null(website)) {
    website <- Sys.getenv("castarter_website")
  } else {
    Sys.setenv(castarter_website = website)
  }

  if (project == "" | website == "") {
    usethis::ui_stop(x = "Both project and website must be set, either with {usethis::ui_code('cas_set_options()')} or directly as a parameter.")
  }

  invisible(list(
    base_folder = base_folder,
    db_folder = db_folder,
    project = project,
    website = website
  ))
}


#' @rdname cas_set_options
#' @examples
#' cas_get_options()
#' @export
cas_get_options <- cas_set_options
