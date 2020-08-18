
proteins_filename <- "proteins.csv"
proteome_filename <- "human.fasta"

testthat::expect_true(file.exists(proteins_filename))
testthat::expect_true(file.exists(proteome_filename))

t <- readr::read_csv(proteins_filename)
head(t)
names(t)

human_proteome <- seqinr::read.fasta(
  proteome_filename,
  as.string = TRUE
)
names(human_proteome)[1:5]

# Get the sequences for proteins that can be found in the proteome
seqs <- tibble::tibble(
  gene_symbol = t$Gene.symbol,
  sequence = NA
)

for (i in seq_along(seqs$gene_symbol)) {
  gene_symbol <- seqs$gene_symbol[i]
  protein_index <- stringr::str_which(
    string = names(human_proteome),
    pattern = gene_symbol
  )
  if (length(protein_index) == 0) {
    message("Cannot find gene symbol ", gene_symbol)
    next()
  }
  if (length(protein_index) > 1) {
    message("Found gene symbol ", gene_symbol, " twice")
    next()
  }
  seqs$sequence[i] <- toupper(
    paste0(seqinr::getSequence(human_proteome[[protein_index]]), collapse = ""))
}

# Create a tibble with all counts
library(dplyr)

counts <- tibble::as_tibble(
    matrix(
    ncol = length(Peptides::aaList()),
    nrow = nrow(seqs),
    data = 0
  )
)
names(counts) <- paste0("f", Peptides::aaList())

peptides <- Peptides::aaList()
n_peptides <- length(peptides)

for (i in seq_len(nrow(seqs))) {
  if (is.na(seqs$sequence[i])) next()
  sequence <- seqs$sequence[i]
  counts[i, ] <- t(stringr::str_count(sequence, peptides))
  counts[i, ] <- counts[i, ] / sum(counts[i, ])
}
counts
t <- dplyr::bind_cols(seqs, counts)
t


readr::write_csv(t, path = "results.csv", na = "?")
