library(tidyverse)
library(readxl)
library(ggtext)
library(RColorBrewer)
library(xlsx)

# raw_taxa_count <- read_csv("Kraken2-output-manipulation-1.0/agg-report-genus.csv") %>%
#     rename_at(
#         vars(contains("../using-metazoa-added/")),
#         funs(str_replace_all(., "../using-metazoa-added/", ""))
#         ) %>%
#     rename_at(
#         vars(contains(".kraken2.txt")),
#         funs(str_replace_all(., ".kraken2.txt", ""))
#     ) %>%
#     rowwise()
# 
# unclassified_counts <- read_csv("Kraken2-output-manipulation-1.0/agg-report-unclassified.csv") %>%
#     rename_at(
#         vars(contains("using-metazoa-added/")),
#         funs(str_replace_all(., "../using-metazoa-added/", ""))
#     ) %>%
#     rename_at(
#         vars(contains(".kraken2.txt")),
#         funs(str_replace_all(., ".kraken2.txt", ""))
#     ) %>%
#     rowwise()
# 
# clean_taxa_count <- bind_rows(raw_taxa_count, unclassified_counts) %>%
#     mutate(`total_counts` = sum(c_across(where(is.numeric)))) %>%
#     ungroup() %>%
#     filter(total_counts >= 10000) %>%
#     select(-total_counts)
# 
# plot_taxa_counts <- clean_taxa_count
# 
# 
# threshold_count <- clean_taxa_count %>%
#     pivot_longer(cols = -Taxa, values_to = "counts") %>%
#     group_by(name) %>%
#     summarize(sum_count = sum(counts)) %>%
#     slice_tail(n=2) %>%
#     summarize(mean(sum_count)) %>%
#     ungroup() %>%
#     as.numeric()
# 
# 
# rel_abund_taxon <- plot_taxa_counts %>%
#     pivot_longer(!Taxa, names_to = "taxon", values_to = "count") %>%
#     mutate(count = if_else(condition = count > threshold_count,
#                             count, 0)) %>%
#     rename(sample_id = taxon, taxon = Taxa) %>%
#     group_by(sample_id) %>%
#     mutate(rel_abund = 100*count / sum(count)) %>%
#     ungroup() %>%
#     select(-count)
# 
# 
# 
# taxon_pool <- rel_abund_taxon %>%
#     group_by(taxon) %>%
#     summarize(pool = max(rel_abund, na.rm = T) < 10,
#               mean = mean(rel_abund, na.rm = T))
# 
# inner_join(rel_abund_taxon, taxon_pool,
#            by="taxon") %>%
#     mutate(taxon = if_else(pool, "Other",
#                            taxon)) %>%
#     mutate(taxon = factor(taxon),
#            taxon = fct_reorder(taxon, mean,
#                                .desc = T),
#            taxon = fct_shift(taxon, n = 1)) %>%
# 
#     ggplot(aes(x = sample_id,
#                y = rel_abund,
#                fill = taxon)) +
#     geom_col()
# 
# ggsave("21-30_stacked_barplot_kraken.tiff",
#        width = 8, height = 4)
# 
# 
# 
# report_rel_abund_genus <- clean_taxa_count %>%
#   pivot_longer(!Taxa, names_to = "taxon", values_to = "count") %>%
#   mutate(count = if_else(condition = count > threshold_count,
#                          count, 0)) %>%
#   rename(sample_id = taxon, taxon = Taxa) %>%
#   group_by(sample_id) %>%
#   mutate(rel_abund = 100*count / sum(count)) %>%
#   mutate(rel_abund = round(rel_abund, digits = 2)) %>%
#   ungroup() %>%
#   select(-count) %>%
#   pivot_wider(names_from = sample_id, values_from = rel_abund)
# 
# report_rel_abund_genus_df <- as.data.frame(report_rel_abund_genus)
# report_rel_abund_genus_df <- report_rel_abund_genus_df[ , order(names(report_rel_abund_genus_df))] %>%
#     select(taxon, everything())
# 
# write.xlsx(report_rel_abund_genus_df,
#                file="kraken_rel_abundance_genus.xlsx", sheetName="genus", append = T,
# row.names=FALSE)
# 
# name_total_reads <- tibble("taxon" = "total_reads")
# 
# total_reads <- clean_taxa_count %>%
#   pivot_longer(!Taxa, names_to = "taxon", values_to = "count") %>%
#   mutate(count = if_else(condition = count > threshold_count,
#                          count, 0)) %>%
#   rename(sample_id = taxon, taxon = Taxa) %>%
#   group_by(sample_id) %>%
#   summarize(count = sum(count)) %>%
#   ungroup() %>%
#   pivot_wider(names_from = sample_id, values_from = count)
# 
# total_reads <- bind_cols(name_total_reads, total_reads)
# 
# report_rel_abund_genus <- clean_taxa_count %>%
#   pivot_longer(!Taxa, names_to = "taxon", values_to = "count") %>%
#   mutate(count = if_else(condition = count > threshold_count,
#                          count, 0)) %>%
#   rename(sample_id = taxon, taxon = Taxa) %>%
#   group_by(sample_id) %>%
#   mutate(rel_abund = 100*count / sum(count)) %>%
#   mutate(rel_abund = round(rel_abund, digits = 2)) %>%
#   ungroup() %>%
#   select(-count) %>%
#   pivot_wider(names_from = sample_id, values_from = rel_abund) %>%
#   bind_rows(., total_reads)
# 
# 
# report_rel_abund_genus_df <- as.data.frame(report_rel_abund_genus)
# report_rel_abund_genus_df <- report_rel_abund_genus_df[ , order(names(report_rel_abund_genus_df))] %>%
#   select(taxon, everything())
# 
# write.xlsx(report_rel_abund_genus_df,
#            file="kraken_rel_abundance_genus.xlsx", sheetName="genus-tr", append = T,
#            row.names=FALSE)
# 

args <- commandArgs(trailingOnly = TRUE)

input_dir <- args[1]
output_path <- args[2]

rel_abund_calculation <- function(input_path){
  taxa_count <- read_csv(input_path) %>%
    rename_at(
      vars(contains("data/processed/kraken2_results/")),
      funs(str_replace_all(., "data/processed/kraken2_results/", ""))
    ) %>%
    rename_at(
      vars(contains(".kraken2.txt")),
      funs(str_replace_all(., ".kraken2.txt", ""))
    ) %>% 
    rowwise() %>%
    mutate(`total_counts` = sum(c_across(where(is.numeric)))) %>%
    ungroup() %>%
    filter(total_counts >= 10000) %>% 
    select(-total_counts)
  
  
  threshold_count <- taxa_count %>% 
    pivot_longer(cols = -Taxa, values_to = "counts") %>%
    group_by(name) %>%
    summarize(sum_count = sum(counts)) %>%
    slice_tail(n=2) %>%
    summarize(mean(sum_count)) %>%
    ungroup() %>%
    as.numeric()
  
  name_total_reads <- tibble("taxon" = "total_reads")
  
  total_reads <- taxa_count %>%
    pivot_longer(!Taxa, names_to = "taxon", values_to = "count") %>%
    mutate(count = if_else(condition = count > 2*threshold_count, 
                           count, 0)) %>%
    rename(sample_id = taxon, taxon = Taxa) %>%
    group_by(sample_id) %>%
    summarize(count = sum(count)) %>%
    ungroup() %>%
    pivot_wider(names_from = sample_id, values_from = count)
  
  total_reads <- bind_cols(name_total_reads, total_reads)
  
  report_rel_abund <- taxa_count %>%
    pivot_longer(!Taxa, names_to = "taxon", values_to = "count") %>%
    mutate(count = if_else(condition = count > 4*threshold_count, 
                           count, 0)) %>%
    rename(sample_id = taxon, taxon = Taxa) %>%
    group_by(sample_id) %>%
    mutate(rel_abund = 100*count / sum(count)) %>%
    mutate(rel_abund = round(rel_abund, digits = 2)) %>%
    ungroup() %>% 
    select(-count) %>%
    pivot_wider(names_from = sample_id, values_from = rel_abund) %>%
    bind_rows(., total_reads)
  
  
  report_rel_abund_df <- as.data.frame(report_rel_abund)
  report_rel_abund_df <- report_rel_abund_df[ , order(names(report_rel_abund_df))] %>%
    select(taxon, everything())
  return(report_rel_abund_df)
  
}

input_dir <- "data/processed/aggregated-results"

species <- paste0(input_dir, "/agg-report-species.csv")
genus <- paste0(input_dir, "/agg-report-genus.csv")
famili <- paste0(input_dir, "/agg-report-family.csv")
ordo <- paste0(input_dir, "/agg-report-ordo.csv")
class <- paste0(input_dir, "/agg-report-class.csv")
phylum <- paste0(input_dir, "/agg-report-phylum.csv")
kingdom <- paste0(input_dir, "/agg-report-kingdom.csv")
domain <- paste0(input_dir, "/agg-report-domain.csv")

report_species <- rel_abund_calculation(species)
report_genus <- rel_abund_calculation(genus)
report_famili <- rel_abund_calculation(famili)
report_ordo <- rel_abund_calculation(ordo)
report_class <- rel_abund_calculation(class)
report_phylum <- rel_abund_calculation(phylum)
report_kingdom <- rel_abund_calculation(kingdom)
report_domain <- rel_abund_calculation(domain)

if (file.exists(output_path)) {
    #Delete file if it exists
    print("Deleting existing file...")
    file.remove(output_path)
}

write.xlsx(report_species, 
           file=output_path, sheetName="species", append = T,
           row.names=FALSE)

write.xlsx(report_genus, 
           file=output_path, sheetName="genus", append = T,
           row.names=FALSE)

write.xlsx(report_famili, 
           file=output_path, sheetName="famili", append = T,
           row.names=FALSE)

write.xlsx(report_ordo, 
           file=output_path, sheetName="ordo", append = T,
           row.names=FALSE)

write.xlsx(report_class, 
           file=output_path, sheetName="class", append = T,
           row.names=FALSE)

write.xlsx(report_phylum,
           file=output_path, sheetName="phylum", append = T,
           row.names=FALSE)

write.xlsx(report_kingdom,
           file=output_path, sheetName="kingdom", append = T,
           row.names=FALSE)

write.xlsx(report_domain,
           file=output_path, sheetName="domain", append = T,
           row.names=FALSE)