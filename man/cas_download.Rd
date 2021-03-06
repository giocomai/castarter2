% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cas_download.R
\name{cas_download}
\alias{cas_download}
\title{Downloads html pages based on a vector of links}
\usage{
cas_download(
  url,
  type = "contents",
  folder = NULL,
  path = NULL,
  file_format = "html",
  size = 500,
  wget_system = FALSE,
  method = "auto",
  missing_pages = TRUE,
  start = 1,
  wait = 1,
  ignore_ssl_certificates = FALSE,
  use_headless_chromium = FALSE,
  headless_chromium_wait = 1,
  use_phantomjs = FALSE,
  create_script = FALSE,
  project = NULL,
  website = NULL,
  base_folder = NULL
)
}
\arguments{
\item{url}{A character vector of urls, or a dataframe with at least two columns named \code{id} and \code{url}.}

\item{type}{Accepted values are either "contents" (default), "index".}

\item{folder}{Defaults to NULL. If given, overrides the "type" param and stores files in given path as a subfolder of project/website. Folder must already exist, and should be empty.}

\item{path}{Defaults to NULL. If given, overrides the "type" and "folder" param and stores files in given path.}

\item{size}{Defaults to 500. It represents the minimum size in bytes that downloaded html files should have: files that are smaller will be downloaded again. Used only when missing_pages == FALSE.}

\item{wget_system}{Logical, defaults to FALSE. Calls wget as a system command through the system() function. Wget must be previously installed on the system.}

\item{method}{Defaults to "auto". Method is passed to the function utils::download.file(); available options are "internal", "wininet" (Windows only) "libcurl", "wget" and "curl". For more information see ?utils::download.file()}

\item{missing_pages}{Logical, defaults to TRUE. If TRUE, verifies if a downloaded html file exists for each element in articlesLinks; when there is no such file, it downloads it.}

\item{start}{Integer. Only url with position higher than start in the url vector will be downloaded: \code{url[start:length(url)]}}

\item{wait}{Defaults to 1. Number of seconds to wait between downloading one page and the next. Can be increased to reduce server load, or can be set to 0 when this is not an issue.}

\item{ignore_ssl_certificates}{Logical, defaults to FALSE. If TRUE it uses wget to download the page, and does not check if the SSL certificate is valid. Useful, for example, for https pages with expired or mis-configured SSL certificate.}

\item{use_headless_chromium}{Logical, defaults to FALSE. If TRUE uses the \code{crrri} package to download pages. Useful in particular when web pages are generated via javascript. See in particular: https://github.com/RLesur/crrri#system-requirements}

\item{headless_chromium_wait}{Numeric, in seconds. How long should headless chrome wait after loading page?}

\item{create_script}{Logical, defaults to FALSE. Tested on Linux only. If TRUE, creates a downloadPages.sh executable file that can be used to download all relevant pages from a terminal.}

\item{project}{Name of 'castarter2' project. Must correspond to the name of a folder in the current working directory.}

\item{website}{Name of a website included in a 'castarter2' project. Must correspond to the name of a sub-folder of the project folder.}
}
\value{
By default, returns nothing, used for its side effects (downloads html files in relevant folder). Download files can then be imported in a vector with the function ImportHtml.
}
\description{
Downloads html pages based on a vector of links.
}
\examples{
if (interactive()) {
\dontrun{
  cas_download(url)
}
}

}
