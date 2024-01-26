# Gene Set Enrichment Analysis

[Video sobre GSEA](https://youtu.be/bT00oJh2x_4)

## GO *Gene Set Enrichment Analysis* con `clusterProfiler`

### Instalación y cargado de paquetes

```r
#BiocManager::install("clusterProfiler")
#BiocManager::install("pathview")
#BiocManager::install("enrichplot")

library(clusterProfiler)
library(enrichplot)
library(ggplot2)
```

### Anotación

```r
#BiocManager::install("org.Hs.eg.db", character.only = TRUE)

library("org.Hs.eg.db", character.only = TRUE)
```

### Preparando los datos

```r
# Lectura de la tabla de genes diferencialemente expresados

# degs = readRDS("data/degs.RDS")

res <- readRDS("res_dseq2.rds")

# necesitamos el log2 fold change 

original_gene_list <- res$log2FoldChange

# Nombramos el vector

names(original_gene_list) <- rownames(res)

# eliminamos cualquier NA 

gene_list<-na.omit(original_gene_list)

# odernamos la lista en orden decreciente (requerido por clusterProfiler)

gene_list = sort(gene_list, decreasing = TRUE)
```

### Gene Set Enrichment

Parámetros:

**keyType** El tipo de ids utilizados en nuestra lista. Receurden que los tipos permitidos se enlistan con el comado `keytypes("org.Hs.eg.db")`. Recueden que si usan algo distinto a Humano deben cambiar su anotación.   
**ont** Ontología. Alguno de "BP" (procesos biológicos), "MF" (función molecular), "CC" (componente celular) o "ALL" (todas)  
**minGSSize** tamaño mínimo de geneSet para analizar.   
**maxGSSize** tamaño máximo de genes anotados para probar. 
**pvalueCutoff** punto de corte del p-value.   
**pAdjustMethod** metodo para ajustar la p, puede ser uno de estos: "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none" 


```r
gse <- gseGO(geneList=gene_list, 
             ont ="ALL", 
             keyType = "ENSEMBL", 
             minGSSize = 3, 
             maxGSSize = 800, 
             pvalueCutoff = 0.05, 
             verbose = TRUE, 
             OrgDb = "org.Hs.eg.db", 
             pAdjustMethod = "BH")
```
Noten que hemos dado toda la lista de genes con su valor de lofFC. Estás enriqueciendo sin un criterio arbitrario (elegido por nosotros), **puro dato duro y maduro**.

## Outputs

### Tabla de resultados
```r
head(gse)
```

### Dotplot
```r
#BiocManager::install("DOSE")

require(DOSE)
dotplot(gse, showCategory=10, split=".sign") + facet_grid(.~.sign)
```

### Ridgeplot

Agrupados por pathways, se generan gráficos de densidad utilizando la frecuencia del logFold Change por gen dentro de cada set. Útil para interpretar vías reguladas al alza o a la baja.

```r
#install.packages(ggridges)

library(ggridges)
ridgeplot(gse) + labs(x = "enrichment distribution")
```

### GSEA Plot  

Método tradicional para visualizar resultados de GSEA.  
  
Parámetros:

**GeneSetID** Entero. Corresponde al pathway en el objeto 'gse'. El primero pathway es el 1, el segundo el 2, *etc*. 

```r
# Usamos el objeto 'geneset' para que siempre coincidan el título y el gene set correspondiente.

geneset = 1
gseaplot(gse, by = "all", title = gse$Description[geneset], geneSetID = geneset)
```


## KEGG *Gene Set Enrichment Analysis* con `clusterProfiler`

Para hacer GSEA con KEGG usaremos la función `gseKEGG()` y tambien cambiaremmos de tipos de ids con `bitr` como en ORA (arriba). 

Como input inicial usaremos `original_gene_list` que creamos para GSEA de GO.

### Prepare Input
```r
# Convertir genes IDs para la función gseKEGG
# Podría ser que se perdieran algunos genes por la conversión

ids<-bitr(names(original_gene_list), fromType = "ENSEMBL", toType = "ENTREZID", OrgDb="org.Hs.eg.db")

# se elimnan ids duplicados (aquí usamos "ENSEMBL", pero debemos usar lo que hayamos empleado en el argumento "fromType")

dedup_ids <- ids[!duplicated(ids[c("ENSEMBL")]),]

# Creamos un nuevo dataframe res2 en cual solo contiene los genes que hicieron match usando ña función bitr

res2 <- res[rownames(res) %in% dedup_ids$ENSEMBL,]

# Creamos una nueva coñumna en degs2 con los correspondientes ENTREZ IDs

res2$Y <- dedup_ids$ENTREZID

# Creamos un vector con el universo de genes

kegg_gene_list <- res2$log2FoldChange

# Nombramos el vector con los ENTREZ ids

names(kegg_gene_list) <- res2$Y

# eliminamos NAs 

kegg_gene_list<-na.omit(kegg_gene_list)

# Ordenamos los datos en orden decreciente (requerido por clusterProfiler)

kegg_gene_list = sort(kegg_gene_list, decreasing = TRUE)

```
### Creación del objeto gseKEGG

Parámetros:

**organism** Cómo en el ORA (arriba) código del organismo de KEGG. En este caso también "hsa" de humano. Lista completa: https://www.genome.jp/kegg/catalog/org_list.html (need the 3 letter code).  
**ont** Ontología. Alguno de "BP" (procesos biológicos), "MF" (función molecular), "CC" (componente celular) o "ALL" (todas)  
**minGSSize** tamaño mínimo de geneSet para analizar.   
**maxGSSize** tamaño máximo de genes anotados para probar. 
**pvalueCutoff** punto de corte del p-value.   
**pAdjustMethod** metodo para ajustar la p, puede ser uno de estos: "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none" 

```r
kk2 <- gseKEGG(geneList     = kegg_gene_list,
               organism     = "hsa",
               minGSSize    = 3,
               maxGSSize    = 800,
               pvalueCutoff = 0.05,
               pAdjustMethod = "none",
               keyType       = "ncbi-geneid")
```

```r
head(kk2, 10)
```

### Dotplot
```r
dotplot(kk2, showCategory = 10, title = "Enriched Pathways" , split=".sign") + facet_grid(.~.sign)
```

### Ridgeplot

Como en GSEA GO, útil para interpretar vías reguladas al alza o a la baja.

```r
ridgeplot(kk2) + labs(x = "enrichment distribution")
```

## GSEA Plot  

Método tradicional para visualizar resultados de GSEA.  
  
Parámetros:

**GeneSetID** Entero. Corresponde al pathway en el objeto 'gse'. El primero pathway es el 1, el segundo el 2, *etc*. 

```r
# Usamos el objeto 'geneset' para que siempre coincidan el título y el gene set correspondiente.

geneset = 1
gseaplot(kk2, by = "all", title = gse$Description[geneset], geneSetID = geneset)
```



## Pathview

Obviamente podemos usar Pathview para mapear los pathways que salieron significativamente representados en nuestro GSEA.

Parámetros:

**gene.data** Esta es la lista `gene_list` creada arriba, el tipo de ids tiene que coincidir con el de `gene.idtype`
**pathway.id** Tenemos que elegir aquí nosotros alguna. Como la idea es visualizar nuestras vías significativamente enriquecidas, pordemos usar los ids de los pathways que nos sale en `head(kk2, 10)`.  
**species** El id de `organism` de la función `enrichKEGG`, en este caso "hsa"
**gene.idtype** el tipo de ids utilizados en `gene.data` pero sacado del objeto `gene.idtype.list`. En este caso tomamos el tercer elemento de esta lista.

```r
#BiocManager::install("pathview")

library(pathview)

# Produce una gráfica de KEGG (PNG) Usaremos hsa05322 proque el primer pathway más enriquecido fue el mismo que graficamos arriba

hsa <- pathview(gene.data=gene_list, pathway.id="hsa05322", species = "hsa", gene.idtype=gene.idtype.list[3])

# Produce una gráfica diferente (PDF)

hsa <- pathview(gene.data=gene_list, pathway.id="hsa05322", species = "hsa", gene.idtype=gene.idtype.list[3], kegg.native = FALSE)
```

Las imágenes se salvan en su directorio de trabajo.


### Más recursos:

### Sobre clusterProfiler 

Sitio web: https://bioconductor.org/packages/release/bioc/vignettes/clusterProfiler/inst/doc/clusterProfiler.html

Tutorial: https://alexslemonade.github.io/refinebio-examples/03-rnaseq/pathway-analysis_rnaseq_01_ora.html

### Sobre enriquecimiento

artículo "Pathway size matters: the influence of pathway granularity on over-representation (enrichment analysis) statistics" https://bmcgenomics.biomedcentral.com/articles/10.1186/s12864-021-07502-8


Tutorial "Functional Analysis for RNA-seq" https://hbctraining.github.io/DGE_workshop_salmon_online/lessons/10_FA_over-representation_analysis.html