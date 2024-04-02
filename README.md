Food Authentification
================

This repository contains codes and snakemake workflow for running food
authentification using NGS amplicon data. This workflow processes fastqs
files for 48 samples with 2 negative controls.

### Dependencies:

- [fastp 0.23.4](https://github.com/OpenGene/fastp)
- [Kraken2 version 2.1.3](https://github.com/DerrickWood/kraken2)
- [multiqc, version 1.16](https://github.com/MultiQC/MultiQC)
- R version 4.1.2 (2021-11-01)
  - `tidyverse` (v. 2.0.0)
  - `readxl` (v. 1.4.3)
  - `rmarkdown` (v. 2.26)
  - `ggtext` (v. 0.1.2)
  - `RColorBrewer` (v. 1.1.3)
  - `formattable` (v. 0.2.1)
  - `knitr` (v. 1.45)

### My computer

    ## R version 4.1.2 (2021-11-01)
    ## Platform: x86_64-pc-linux-gnu (64-bit)
    ## Running under: Ubuntu 22.04.3 LTS
    ## 
    ## Matrix products: default
    ## BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.10.0
    ## LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.10.0
    ## 
    ## locale:
    ##  [1] LC_CTYPE=en_US.UTF-8          LC_NUMERIC=C                 
    ##  [3] LC_TIME=id_ID.UTF-8           LC_COLLATE=en_US.UTF-8       
    ##  [5] LC_MONETARY=id_ID.UTF-8       LC_MESSAGES=en_US.UTF-8      
    ##  [7] LC_PAPER=id_ID.UTF-8          LC_NAME=id_ID.UTF-8          
    ##  [9] LC_ADDRESS=id_ID.UTF-8        LC_TELEPHONE=id_ID.UTF-8     
    ## [11] LC_MEASUREMENT=id_ID.UTF-8    LC_IDENTIFICATION=id_ID.UTF-8
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ##  [1] knitr_1.45         formattable_0.2.1  xlsx_0.6.5         RColorBrewer_1.1-3
    ##  [5] ggtext_0.1.2       readxl_1.4.3       lubridate_1.9.3    forcats_1.0.0     
    ##  [9] stringr_1.5.0      dplyr_1.1.3        purrr_1.0.2        readr_2.1.4       
    ## [13] tidyr_1.3.0        tibble_3.2.1       ggplot2_3.4.3      tidyverse_2.0.0   
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.11       cellranger_1.1.0  pillar_1.9.0      compiler_4.1.2   
    ##  [5] tools_4.1.2       digest_0.6.33     timechange_0.2.0  evaluate_0.22    
    ##  [9] lifecycle_1.0.3   gtable_0.3.4      pkgconfig_2.0.3   rlang_1.1.1      
    ## [13] cli_3.6.1         rstudioapi_0.15.0 yaml_2.3.7        xfun_0.40        
    ## [17] fastmap_1.1.1     rJava_1.0-6       xml2_1.3.5        withr_2.5.1      
    ## [21] htmlwidgets_1.6.2 xlsxjars_0.6.1    generics_0.1.3    vctrs_0.6.3      
    ## [25] hms_1.1.3         gridtext_0.1.5    grid_4.1.2        tidyselect_1.2.0 
    ## [29] glue_1.6.2        R6_2.5.1          fansi_1.0.4       rmarkdown_2.26   
    ## [33] tzdb_0.4.0        magrittr_2.0.3    scales_1.2.1      htmltools_0.5.7  
    ## [37] colorspace_2.1-0  utf8_1.2.3        stringi_1.7.12    munsell_0.5.0

### Preparation steps

- Install the required R packages: `Rscript install_packages.R`

- Install snakemake Please follow this
  [link](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html)
  for the instalation.

- Install [fastp 0.23.4](https://github.com/OpenGene/fastp) and
  [multiqc, version 1.16](https://github.com/MultiQC/MultiQC) using
  conda or mamba

- Install kraken2 Please follow this
  [link](https://github.com/DerrickWood/kraken2/blob/master/docs/MANUAL.markdown)
  for the installation.

- Ask the author to get the kraken2 pre-built database
