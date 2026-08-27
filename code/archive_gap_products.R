##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##  Archive GAP_PRODUCTS production run 
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

rm(list = ls())

## Select the location of GAP_PRODUCTS_Archives, currently on the G drive
#Y:/RACE_GF/GAP_PRODUCTS_Archives
archive_path <- rstudioapi::selectDirectory(caption = "Select Archive Directory")
if (!dir.exists(paths = archive_path))
  stop("The provided argument `archive_path` does not exist.")
path <- "temp"

if (file.exists(paste0(path, "/report_changes.txt"))) {
  ## Copy changelog to news section
  fs::file_copy(
    path = paste0(path, "/report_changes.txt"),
    new_path = paste0("content/intro-news/", 
                      readLines(con = paste0(path, "/timestamp.txt")), ".txt")
  )
} else (stop("report_changes.txt does not exist within argument `path`"))

## Create a new directory with the timestamp as the title. This is the 
## directory that will store the archived files.
dir.create(path = readLines(con = paste0(path, "/timestamp.txt")))

## Copy the contents in the code/, functions/, and temp/ directories into the 
## archive directory
file.copy(from = "gap_products.Rproj", 
          to = readLines(con = paste0(path, "/timestamp.txt")))
fs::dir_copy(path = "code/", 
             new_path = readLines(con = paste0(path, "/timestamp.txt")))
fs::dir_copy(path = "functions/", 
             new_path = readLines(con = paste0(path, "/timestamp.txt")))
fs::dir_copy(path = "temp/", 
             new_path = readLines(con = paste0(path, "/timestamp.txt")))

## Zip archive folder and move to archive directory
utils::zip(files = readLines(con = paste0(path, "/timestamp.txt")),
           zipfile = paste0(getwd(), "/", 
                            readLines(con = paste0(path, "/timestamp.txt")), 
                            ".zip") )

fs::file_move(path = paste0(readLines(con = paste0(path, "/timestamp.txt")), 
                            ".zip"),
              new_path = archive_path)

## Remove archive folder from local repo (or do this manually if you get an error)
fs::file_delete(path = readLines(con = paste0(path, "/timestamp.txt")))
