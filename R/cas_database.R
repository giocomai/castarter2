#' Creates the base folder where `castarter` stores the project database.
#'
#' @param ask Logical, defaults to TRUE. If FALSE, and database folder does not exist, it just creates it without asking (useful for non-interactive sessions).
#'
#' @family database functions
#'
#' @return Nothing, used for its side effects.
#' @export
#'
#' @examples
#' cas_create_db_folder(path = fs::path(fs::path_temp(), "cas_data"))
cas_create_db_folder <- function(path = NULL,
                                 ask = TRUE) {
  if (is.null(path)) {
    db_path <- cas_get_db_folder()
  } else {
    db_path <- path
  }

  if (fs::file_exists(db_path) == FALSE) {
    if (ask == FALSE) {
      fs::dir_create(path = db_path, recurse = TRUE)
    } else {
      usethis::ui_info(glue::glue("The database folder {{usethis::ui_path(cas_get_db_folder())}} does not exist. If you prefer to store database files elsewhere, reply negatively and set your preferred database folder with `cas_set_db_folder()`"))
      check <- usethis::ui_yeah(glue::glue("Do you want to create {{usethis::ui_path(cas_get_db_folder())}} for storing data in a local database?"))
      if (check == TRUE) {
        fs::dir_create(path = db_path, recurse = TRUE)
      }
    }
    if (fs::file_exists(db_path) == FALSE) {
      usethis::ui_stop("This function requires a valid database folder.")
    }
  }
}


#' Set folder for storing the database
#'
#' Consider using a folder out of your current project directory, e.g. `cas_set_db_folder("~/R/cas_data/")`: you will be able to use the same database in different projects, and prevent database files from being sync-ed if you use services such as Nextcloud or Dropbox.
#'
#' @param path A path to a location used for storing the database. If the folder does not exist, it will be created.
#'
#' @family database functions
#'
#' @return The path to the database folder, if previously set; the same path as given to the function; or the default, `cas_data` is none is given.
#' @export
#' @examples
#' cas_set_db_folder(fs::path(fs::path_home_r(), "R", "cas_data"))
#'
#' cas_set_db_folder(fs::path(fs::path_temp(), "cas_data"))
cas_set_db_folder <- function(path = NULL) {
  if (is.null(path)) {
    path <- Sys.getenv("castarter_database_folder")
  } else {
    Sys.setenv(castarter_database_folder = path)
  }
  if (path == "") {
    path <- fs::path("castarter_data")
  }
  invisible(path)
}

#' @rdname cas_set_db_folder
#' @examples
#' cas_get_db_folder()
#' @export
cas_get_db_folder <- cas_set_db_folder



#' Set database connection settings for the session
#'
#' @param db_settings A list of database connection settings (see example)
#' @param driver A database driver. Common database drivers include `MySQL`, `PostgreSQL`, and `MariaDB`. See `unique(odbc::odbcListDrivers()[[1]])` for a list of locally available drivers.
#' @param host Host address, e.g. "localhost".
#' @param port Port to use to connect to the database.
#' @param database Database name.
#' @param user Database user name.
#' @param pwd Password for the database user.
#'
#' @family database functions
#'
#' @return A list with all given parameters (invisibly).
#' @export
#'
#' @examples
#' \donttest{
#' if (interactive()) {
#'
#'   # Settings can be provided either as a list
#'   db_settings <- list(
#'     driver = "MySQL",
#'     host = "localhost",
#'     port = 3306,
#'     database = "castarter",
#'     user = "secret_username",
#'     pwd = "secret_password"
#'   )
#'
#'   cas_set_db(db_settings)
#'
#'   # or as parameters
#'
#'   cas_set_db(
#'     driver = "MySQL",
#'     host = "localhost",
#'     port = 3306,
#'     database = "castarter",
#'     user = "secret_username",
#'     pwd = "secret_password"
#'   )
#' }
#' }
cas_set_db <- function(db_settings = NULL,
                       driver = NULL,
                       host = NULL,
                       port,
                       database,
                       user,
                       pwd) {
  if (is.null(db_settings) == TRUE) {
    if (is.null(driver) == FALSE) Sys.setenv(castarter_db_driver = driver)
    if (is.null(host) == FALSE) Sys.setenv(castarter_db_host = host)
    if (is.null(port) == FALSE) Sys.setenv(castarter_db_port = port)
    if (is.null(database) == FALSE) Sys.setenv(castarter_db_database = database)
    if (is.null(user) == FALSE) Sys.setenv(castarter_db_user = user)
    if (is.null(pwd) == FALSE) Sys.setenv(castarter_db_pwd = pwd)
    return(invisible(
      list(
        driver = driver,
        host = host,
        port = port,
        database = database,
        user = user,
        pwd = pwd
      )
    ))
  } else {
    Sys.setenv(castarter_db_driver = db_settings$driver)
    Sys.setenv(castarter_db_host = db_settings$host)
    Sys.setenv(castarter_db_port = db_settings$port)
    Sys.setenv(castarter_db_database = db_settings$database)
    Sys.setenv(castarter_db_user = db_settings$user)
    Sys.setenv(castarter_db_pwd = db_settings$pwd)
    return(invisible(db_settings))
  }
}

#' Get database connection settings from the environment
#'
#' Typically set with `cas_set_db()`
#'
#' @family database functions
#'
#' @return A list with all database parameters as stored in environment variables.
#' @export
#'
#' @examples
#'
#' cas_get_db_settings()
cas_get_db_settings <- function() {
  list(
    driver = Sys.getenv("castarter_db_driver"),
    host = Sys.getenv("castarter_db_host"),
    port = Sys.getenv("castarter_db_port"),
    database = Sys.getenv("castarter_db_database"),
    user = Sys.getenv("castarter_db_user"),
    pwd = Sys.getenv("castarter_db_pwd")
  )
}



#' Gets location of database file
#'
#' @param type Defaults to NULL. Deprecated. If given, type of database file to output.
#'
#' @return A character vector of length one with location of the SQLite database file.
#' @export
#'
#' @examples
#'
#' cas_set_db_folder(path = tempdir())
#' sqlite_db_file_location <- cas_get_db_file(project = "test-project") # outputs location of database file
#' sqlite_db_file_location
cas_get_db_file <- function(project = cas_get_options()$project,
                            db_folder = NULL,
                            type = NULL) {
  if (is.null(db_folder)) {
    db_folder <- cas_get_db_folder()
  }

  if (is.null(type)) {
    fs::path(
      db_folder,
      stringr::str_c(
        "cas_",
        project,
        "_db.sqlite"
      ) %>%
        fs::path_sanitize()
    )
  } else {
    fs::path(
      db_folder,
      stringr::str_c(
        "cas_",
        project,
        "_",
        type,
        "_db_",
        ".sqlite"
      ) %>%
        fs::path_sanitize()
    )
  }
}

#' Enable caching for the current session
#'
#' @param SQLite Logical, defaults to TRUE. Set to FALSE to use custom database options. See `cas_set_db()` for details.
#'
#' @family database functions
#'
#' @return Nothing, used for its side effects.
#' @export
#' @examples
#' \donttest{
#' if (interactive()) {
#'   cas_enable_db()
#' }
#' }
cas_enable_db <- function(SQLite = TRUE) {
  Sys.setenv(castarter_database = TRUE)
  Sys.setenv(castarter_database_SQLite = SQLite)
}


#' Disable caching for the current session
#'
#' @family database functions
#'
#' @return Nothing, used for its side effects.
#' @export
#' @examples
#' \donttest{
#' if (interactive()) {
#'   cas_disable_db()
#' }
#' }
cas_disable_db <- function() {
  Sys.setenv(castarter_database = FALSE)
}

#' Check caching status in the current session, and override it upon request
#'
#' Mostly used internally in functions, exported for reference.
#'
#' @param use_db Defaults to NULL. If NULL, checks current use_db settings. If given, returns given value, ignoring use_db.
#'
#' @family database functions
#'
#' @return Either TRUE or FALSE, depending on current use_db settings.
#' @export
#' @examples
#' cas_check_use_db()
cas_check_use_db <- function(use_db = NULL) {
  if (is.null(use_db) == FALSE) {
    return(as.logical(use_db))
  }
  current_database <- Sys.getenv("castarter_database")
  if (current_database == "") {
    as.logical(FALSE)
  } else {
    as.logical(current_database)
  }
}

#' Checks if database folder exists, if not returns an informative message
#'
#' @family database functions
#'
#' @return If the database folder exists, returns TRUE. Otherwise throws an error.
#' @export
#'
#' @examples
#'
#' # If database folder does not exist, it throws an error
#' tryCatch(cas_check_db_folder(),
#'   error = function(e) {
#'     return(e)
#'   }
#' )
#'
#' # Create database folder
#' cas_set_db_folder(path = fs::path(
#'   tempdir(),
#'   "cas_db_folder"
#' ))
#' cas_create_db_folder(ask = FALSE)
#'
#' cas_check_db_folder()
cas_check_db_folder <- function() {
  if (fs::file_exists(cas_get_db_folder()) == FALSE) {
    usethis::ui_stop(paste(
      "Database folder does not exist. Set it with",
      usethis::ui_code("cas_set_db_folder()"),
      "and create it with",
      usethis::ui_code("cas_create_db_folder()")
    ))
  }
  TRUE
}



#' Return a connection to be used for caching
#'
#' @param db_connection Defaults to NULL. If NULL, uses local SQLite database.
#'   If given, must be a connection object or a list with relevant connection
#'   settings (see example).
#' @param RSQLite Defaults to NULL, expected either NULL, logical, or character.
#'   If set to `FALSE`, details on the database connection must be given either
#'   as a named list in the connection parameter, or with [cas_set_db()] as
#'   environment variables. If a character vector, it can either be a path to a
#'   folder or the a sqlite database file.
#' @param use_db Defaults to NULL. If given, it should be given either TRUE or
#'   FALSE. Typically set with `cas_enable_db()` or `cas_disable_db()`.
#'
#' @family database functions
#'
#' @return A connection object.
#' @export
#'
#' @examples
#' \donttest{
#' if (interactive()) {
#'   db_connection <- pool::dbPool(
#'     RSQLite::SQLite(), # or e.g. odbc::odbc(),
#'     Driver =  ":memory:", # or e.g. "MariaDB",
#'     Host = "localhost",
#'     database = "example_db",
#'     UID = "example_user",
#'     PWD = "example_pwd"
#'   )
#'   cas_connect_to_db(db_connection)
#'
#'
#'   db_settings <- list(
#'     driver = "MySQL",
#'     host = "localhost",
#'     port = 3306,
#'     database = "castarter",
#'     user = "secret_username",
#'     pwd = "secret_password"
#'   )
#'
#'   cas_connect_to_db(db_settings)
#' }
#' }
#'
cas_connect_to_db <- function(db_connection = NULL,
                              RSQLite = NULL,
                              use_db = NULL,
                              project = cas_get_options()$project) {
  if (isFALSE(x = cas_check_use_db(use_db))) {
    return(NULL)
  }

  if (is.null(db_connection) == FALSE & is.list(db_connection) == FALSE) {
    if (DBI::dbIsValid(db_connection) == FALSE) {
      db_connection <- NULL
    }
  }

  if (is.null(db_connection)) {
    if (is.null(RSQLite)) {
      RSQLite <- as.logical(Sys.getenv(x = "cas_database_SQLite", unset = TRUE))
    } 
    
    if (is.null(RSQLite) == FALSE) {
      if (isTRUE(RSQLite)) {
        cas_check_db_folder()
        db_file <- cas_get_db_file(project = project)
      } else if (is.character(RSQLite)) {
        if (nchar(fs::path_ext(RSQLite)) > 0) {
          db_file <- RSQLite
        } else {
          db_file <- cas_get_db_file(
            db_folder = RSQLite,
            project = project
          )
        }
      }

      if (fs::file_exists(db_file) == FALSE) {
        db <- pool::dbPool(
          drv = RSQLite::SQLite(),
          dbname = db_file
        )
      }

      db <- pool::dbPool(
        drv = RSQLite::SQLite(),
        dbname = db_file
      )
      return(db)
    } else {
      db_connection <- cas_get_db_settings()

      if (db_connection[["driver"]] == "SQLite") {
        if (requireNamespace("RSQLite", quietly = TRUE) == FALSE) {
          usethis::ui_stop(x = "To use SQLite databases you need to install the package `RSQLite`.")
        }
        drv <- RSQLite::SQLite()
      } else {
        if (requireNamespace("odbc", quietly = TRUE) == FALSE) {
          usethis::ui_stop(x = "To use custom databases you need to install the package `odbc`, or provide your connection directly to all functions.")
        }
        drv <- odbc::odbc()
      }

      db <- pool::dbPool(
        drv = drv,
        driver = db_connection[["driver"]],
        host = db_connection[["host"]],
        port = as.integer(db_connection[["port"]]),
        database = db_connection[["database"]],
        user = db_connection[["user"]],
        pwd = db_connection[["pwd"]]
      )
      return(db)
    }
  } else {
    if (is.list(db_connection)) {
      if (db_connection[["driver"]] == "SQLite") {
        if (requireNamespace("RSQLite", quietly = TRUE) == FALSE) {
          usethis::ui_stop(x = "To use SQLite databases you need to install the package `RSQLite`.")
        }
        drv <- RSQLite::SQLite()
      } else {
        if (requireNamespace("odbc", quietly = TRUE) == FALSE) {
          usethis::ui_stop(x = "To use custom databases you need to install the package `odbc`, or provide your connection directly to all functions.")
        }
        drv <- odbc::odbc()
      }

      db <- pool::dbPool(
        drv = drv,
        driver = db_connection[["driver"]],
        host = db_connection[["host"]],
        port = as.integer(db_connection[["port"]]),
        database = db_connection[["database"]],
        dbname = db_connection[["database"]],
        user = db_connection[["user"]],
        pwd = db_connection[["pwd"]]
      )
      return(db)
    } else {
      return(db_connection)
    }
  }
}




#' Ensure that connection to database is disconnected consistently
#'
#' @param use_db Defaults to NULL. If given, it should be given either TRUE or FALSE. Typically set with `cas_enable_db()` or `cas_disable_db()`.
#' @param db_connection Defaults to NULL. If NULL, and database is enabled, `castarter` will use a local sqlite database. A custom connection to other databases can be given (see vignette `castarter_db_management` for details).
#' @param disconnect_db Defaults to TRUE. If FALSE, leaves the connection to database open.
#'
#' @family database functions
#'
#' @return Nothing, used for its side effects.
#' @export
#'
#' @examples
#' cas_disconnect_from_db()
cas_disconnect_from_db <- function(use_db = NULL,
                                   db_connection = NULL,
                                   disconnect_db = TRUE) {
  if (isFALSE(disconnect_db)) {
    return(invisible(NULL))
  }

  if (isTRUE(cas_check_use_db(use_db))) {
    db <- cas_connect_to_db(
      db_connection = db_connection,
      use_db = use_db
    )

    if (pool::dbIsValid(dbObj = db)) {
      if (inherits(db, "Pool")) {
        pool::poolClose(db)
      } else {
        DBI::dbDisconnect(db)
      }
    }
  }
}


#' Generic function for writing to database
#'
#' @param df A data frame. Must correspond with the type of data expected for each table.
#' @param table Name of the table. See readme for details.
#' @param overwrite Logical, defaults to FALSE. If TRUE, checks if matching data are previously held in the table and overwrites them. This should be used with caution, as it may overwrite completely the selected table.
#'
#' @family database functions
#'
#' @inheritParams cas_connect_to_db
#' @inheritParams cas_disconnect_from_db
#'
#' @return If successful, returns silently the same data frame provided as input and written to the database. Returns silently NULL, if nothing is added, e.g. because `use_db` is set to FALSE.
#' @export
#'
#' @examples
#'
#' cas_set_options(
#'   base_folder = fs::path(tempdir(), "R", "castarter_data"),
#'   project = "example_project",
#'   website = "example_website"
#' )
#' cas_enable_db()
#'
#'
#' urls_df <- cas_build_urls(
#'   url_beginning = "https://www.example.com/news/",
#'   start_page = 1,
#'   end_page = 10
#' )
#'
#' cas_write_to_db(
#'   df = urls_df,
#'   table = "index_id"
#' )
#'
cas_write_to_db <- function(df,
                            table,
                            use_db = NULL,
                            overwrite = FALSE,
                            db_connection = NULL,
                            disconnect_db = TRUE) {
  if (cas_check_use_db(use_db = use_db) == FALSE) {
    return(invisible(NULL))
  }

  db <- cas_connect_to_db(
    db_connection = db_connection,
    use_db = use_db
  )

  if (pool::dbExistsTable(conn = db, name = table) == FALSE) {
    # do nothing: if table does not exist, previous data cannot be there
  } else {
    if (overwrite == TRUE) {
      # TODO
    }
  }

  if (table == "index_id") {
    if (identical(colnames(df), colnames(casdb_empty_index_id)) & identical(sapply(df, class), sapply(casdb_empty_index_id, class))) {
      pool::dbWriteTable(db,
        name = table,
        value = df,
        append = TRUE
      )
    } else {
      usethis::ui_stop("Incomptabile data frame passed to `index_id`. `df` should have a numeric `index_id` column, and a character `url` and `type` column.")
    }
  }

  cas_disconnect_from_db(
    use_db = use_db,
    db_connection = db,
    disconnect_db = disconnect_db
  )
}


#' Reads data from local database
#'
#' @family database functions
#'
#' @inheritParams cas_write_to_db
#'
#' @return
#' @export
#'
#' @examples
#' cas_set_options(
#'   base_folder = fs::path(tempdir(), "R", "castarter_data"),
#'   project = "example_project",
#'   website = "example_website"
#' )
#' cas_enable_db()
#'
#'
#' urls_df <- cas_build_urls(
#'   url_beginning = "https://www.example.com/news/",
#'   start_page = 1,
#'   end_page = 10
#' )
#'
#' cas_write_to_db(
#'   df = urls_df,
#'   table = "index_id"
#' )
#'
#' cas_read_from_db(table = "index_id")
#'
cas_read_from_db <- function(table,
                             use_db = NULL,
                             db_connection = NULL,
                             disconnect_db = TRUE) {
  if (cas_check_use_db(use_db = use_db) == FALSE) {
    return(invisible(NULL))
  }

  db <- cas_connect_to_db(
    db_connection = db_connection,
    use_db = use_db
  )

  if (pool::dbExistsTable(conn = db, name = table) == FALSE) {
    # do nothing: if table does not exist, previous data cannot be there
  } else {
    output_df <- pool::dbReadTable(db,
      name = table
    ) %>%
      dplyr::collect()
  }

  cas_disconnect_from_db(
    use_db = use_db,
    db_connection = db,
    disconnect_db = disconnect_db
  )

  output_df
}
