
proteome_filename <- "human.fasta"

testthat::expect_true(file.exists(proteome_filename))

human_proteome <- seqinr::read.fasta(
  proteome_filename,
  as.string = TRUE
)
names(human_proteome)[1:5]

t <- tibble::tibble(
  name = seqinr::getName(human_proteome),
  sequence = toupper(unlist(seqinr::getSequence(human_proteome, as.string = TRUE))),
  n_leucine = NA
)
library(dplyr)
t$n_leucine <- stringr::str_count(t$sequence, "L")
t
t <- t %>% dplyr::arrange(desc(n_leucine))
t


readr::write_csv(head(t, n = 100), path = "n_leucine.csv")
