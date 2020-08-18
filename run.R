
excelsheet_filename <- "proteins.xlsx"
testthat::expect_true(file.exists(excelsheet_filename))

t <- openxlsx::read.read.xlsx(excelsheet_filename)
