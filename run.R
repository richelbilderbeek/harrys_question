
proteins_filename <- "proteins.csv"
proteome_filename <- "human.fasta"

testthat::expect_true(file.exists(proteins_filename))
testthat::expect_true(file.exists(proteome_filename))

t <- readr::read_csv(proteins_filename)
head(t)
names(t)
t$ID

human_proteome <- seqinr::read.fasta(
  proteome_filename,
  as.string = TRUE
)

names(human_proteome)[1:5]

seqs <- tibble::tibble(
  gene_symbol = t$Gene.symbol,
  sequence = NA
)

for (i in seq_along(seqs$gene_symbol)) {
  gene_symbol <- seqs$gene_symbol[i]
  protein_index <- stringr::str_which(
    string = names(human_proteome),
    pattern = paste0("\\|", gene_symbol, "\\|")
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
readr::write_csv(seqs, path = "results.csv", na = "?")
