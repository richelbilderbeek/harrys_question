library(dplyr)

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
  n = NA,
  n_leucine = NA
)
t$n <- stringr::str_length(t$sequence)
t$n_leucine <- stringr::str_count(t$sequence, "L")

n <- sum(t$n)
n_leucine <- sum(t$n_leucine)
n_leucine / n

# 0.09899836
