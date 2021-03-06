% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cas_kwic.R
\name{cas_kwic_single_string}
\alias{cas_kwic_single_string}
\title{Adds a column with n words before and after the selected string to see keywords in context}
\usage{
cas_kwic_single_string(
  corpus,
  string,
  text = text,
  words_before = 5,
  words_after = 5,
  same_sentence = TRUE,
  period_at_end_of_sentence = TRUE,
  ignore_case = TRUE,
  full_words_only = FALSE,
  full_word_with_partial_match = TRUE,
  string_column_name = string
)
}
\arguments{
\item{corpus}{A textual corpus as a data frame.}

\item{string}{A string, typically of one or more words, to be used to break text. Should be of length 1 or length equal to the number of rows.}

\item{text}{Defaults to text. The unquoted name of the column of the corpus data frame to be used for matching.}

\item{words_before}{Integer, defaults to 5. Number of columns to include in the \code{before} column.}

\item{words_after}{Integer, defaults to 5. Number of columns to include in the \code{after} column.}

\item{same_sentence}{Logical, defaults to TRUE. If TRUE, before and after include only words found in the sentence including the matched string.}

\item{period_at_end_of_sentence}{Logical, defaults to TRUE. If TRUE, a period (".") is always included at the end of a sentence. Relevant only if \code{same_sentence} is set to TRUE.}

\item{ignore_case}{Defaults to TRUE.}

\item{full_words_only}{Defaults to FALSE. If FALSE, string is counted even when the it is found in the middle of a word (e.g. if FALSE, "ratio" would be counted as match in the word "irrational"). Set to FALSE also if you want to use your own regex.}

\item{full_word_with_partial_match}{Defaults to TRUE. If TRUE, if there is a partial match of the string, the \code{string} column still includes the full word where the match has been found. and Relevant only when \code{full_words_only} is set to FALSE.}

\item{string_column_name}{Defaults to 'string'. The unquoted name of the column to be used for the word in the output.}
}
\value{
A data frame (a tibble), with the same columns as input, plus three columns: before, string, and after. Only rows where the string is found are included.
}
\description{
Adds a column with n words before and after the selected string to see keywords in context
}
\examples{

cas_kwic_single_string(
  corpus = tifkremlinen::kremlin_en,
  string = "West"
)
}
