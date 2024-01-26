
#Set the path to the Kallisto output directory, it should only include the output files abundance.tsv of each sample):
KALLISTO_OUT_DIR <- "/Users/jazminvaleriano/Documents/lncRNA/kallisto_out/all_samples"

#Load necessary library
library(dplyr)

# Get a list of all abundance.tsv files in the directory
files <- list.files(KALLISTO_OUT_DIR, pattern = "abundance.tsv", full.names = TRUE)


# Initialize an empty data frame to store gene-level expression
gene_expression <- data.frame(target_id = character(0), stringsAsFactors = FALSE)

# Loop through each file
for (file in files) {
  # Extract the sample name from the file path
  sample_name <- tools::file_path_sans_ext(basename(file))
  
  # Read the abundance.tsv file
  abundance_data <- read.delim(file, header = TRUE, stringsAsFactors = FALSE)
  
  # Sum the transcript-level abundance to get gene-level abundance
  gene_expression <- gene_expression %>%
    full_join(abundance_data %>% 
                group_by(target_id) %>% 
                summarise(expression = sum(tpm)),
              by = "target_id",
              suffix = c("", sample_name))
}

# Set the gene IDs as row names
rownames(gene_expression) <- gene_expression$target_id
gene_expression$target_id <- NULL

# Replace NA values with 0
gene_expression[is.na(gene_expression)] <- 0

# Save the gene-level expression table to a file
write.table(gene_expression, file = "gene_expression_table.txt", sep = "\t", quote = FALSE)