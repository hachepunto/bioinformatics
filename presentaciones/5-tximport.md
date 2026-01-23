
## Ejercicio de expresión diferencial a partir de archivos de cuantificación de Kallisto usando tximport y DESeq2:
 
### Objetivos:
1. obtener una matriz de expresión normalizada con los nombres y otra con los ids de los genes
2. obtener la lista de genes diferencialmente expresados
3. obtener las vías de señalización enriquecidas

### Pasos:
1. Crear un archivo con la información de nuestras muestras
2. Usar tximport para integrar los archivos de cada muestra individual (a nivel de transcrito) en una sola matriz a nivel de gen. Tximport es una función que toma a) un archivo de referencia con los ids de los transcritos y el id del gene al que pertenecen, y b) los archivos de expresión.
   1. cargar mis_muestras.tsv
   2. cargar el archivo de referencia (geneId_transcriptId_geneName_chr22.txt)
   3. correr tximport con la referencia y nuestros datos de kallisto
3. Utilizar DESeq2 para identificar genes diferencialmente expresados
4. Utilizar EnrichR para identificar las vías de señalización enriquecidas
---

## Paso 0: Abrir Rstudio en drona en un navegador
```
drona.inmegen.gob.mx:8787 
```

## Paso 1: crear el archivo con la información de nuestras muestras

En la terminal de Rstudio (ojo: no la consola) ejecuta los siguientes comandos:

```
ls ~/datos.taller/salida_kallisto_*/abundance.tsv | cut -d"/" -f5 | cut -d"_" -f3-4 > ids.txt
ls ~/datos.taller/salida_kallisto_*/abundance.tsv | cut -d"/" -f5 | cut -d"_" -f3 > condicion.txt
ls ~/datos.taller/salida_kallisto_*/abundance.tsv > rutas.txt
paste ids.txt condicion.txt rutas.txt > mis_muestras.tsv
```

Confirma que en el archivo mis_muestras.tsv tengas 3 columnas: 1) id de la muestra, 2) el tipo o la condicion de la muestra y 3) la ruta absoluta donde se encuentran los archivos de abundancias para cada muestra (6 en total) generados por kallisto.

```
more mis_muestras.tsv
```


## Paso 2: Tximport 

https://bioconductor.org/packages/release/bioc/html/tximport.html

Para empezar a crear un script con todos los pasos que vamos a ejecutar, abran en Rstudio un Rscript:
File -> New File -> Rscript

Hagan click en el icono del diskette para guardar el archivo y ponganle de nombre: ejercicio_deseq2.R

De ahora en adelante todos los pasos que hagamos los copian primero en su Rscript y desde ahi los ejecutan en la consola, igual como lo hicieron en las sesiones pasadas de R.

Definimos nuestro directorio de trabajo:

```
setwd("~")
```

Cargamos las bibliotecas que vamos a utilizar:

```
library(tximport)
library(DESeq2)
```

Empecemos por consultar la ayuda de tximport para saber que parámetros recibe la función.
```
help("tximport")
```


### Paso 2.1: cargar archivo con la información de las muestras

Cargamos el archivo con los nombres de las muestras y las rutas a los archivos de expresión generados por Kallisto. 

```
samples <- read.table("mis_muestras.tsv",sep="\t",header=F)
samples
```

vamos a ponerle nombre a las columnas

```
colnames(samples) <- c("Muestra","Condicion","Archivo")
samples
```

La función tximport espera un vector con las rutas de los archivo de expresión con el atributo names que corresponda al nombre de la muestra

```
files <- as.vector(samples$Archivo)
names(files) <- samples$Muestra 
files
```

### Paso 2.2: cargar el archivo de referencia 

```
refChr22 <- read.table("/home/instalaciones/geneId_transcriptId_geneName_chr22.txt", sep="\t", header=F)
colnames(refChr22) <- c("gene_id","transcript_id","gene_name")
```

exploramos la tabla que acabamos de generar ...

nuestro archivo de referencia solo necesita estas dos columnas:

```
tx2gene <- refChr22[,c("transcript_id","gene_id")]
head(tx2gene)
```
 
### Paso 2.3: ejecutar tximport

```
txi <- tximport(files, 
                type = "kallisto", 
                tx2gene = tx2gene,
                ignoreTxVersion = T,
                dropInfReps=TRUE)
str(txi)
head(txi$counts)
head(txi$abundance)
```

Creamos matriz de expresión normalizada(TPM) 

```
table.out <- txi$abundance
head(table.out)
dim(table.out)
```

mejoramos la matriz de expresión incluyendo los nombres de los genes también

```
geneId_geneName <- unique(refChr22[,-2])
table.out.names <- merge(geneId_geneName,table.out,by.x='gene_id',by.y=0)
dim(table.out.names)
head(table.out.names)
write.table(table.out.names, 
            file="exprTable.tsv", sep="\t", 
            quote=F, 
            col.names=T,
            row.names=F)
```

### Ejercicio para ver como se obtiene el tpm:

Para entender como se obtiene este valor a partir del número de lecturas seguimos las instrucciones para calcularlo de: https://www.rna-seqblog.com/rpkm-fpkm-and-tpm-clearly-explained/ 

"Here’s how you calculate TPM: 
 1. Divide the read counts by the length of each gene in kilobases. This gives you reads per kilobase (RPK). 
 2. Count up all the RPK values in a sample and divide this number by 1,000,000. This is your “per million” scaling factor. 
 3. Divide the RPK values by the “per million” scaling factor. This gives you TPM. "

```
m1 <- read.table(samples[1,"Archivo"],
                        sep="\t",
                        header=T)
head(m1)

# aqui vamos a calcular el valor de rpk
m1$rpk <- m1$est_counts / m1$eff_length
m1[1:20,]

scaling_factor <- sum(m1$rpk) / 1000000
scaling_factor

m1$miTPM <- m1$rpk / scaling_factor
m1[1:20,-6]

totalTPM <- sum(m1$tpm)
totalTPM
```

## Paso 3: Expresión diferencial con DESeq2  

https://bioconductor.org/packages/release/bioc/vignettes/DESeq2/inst/doc/DESeq2.html

```
coldata <- data.frame(condition = samples$Condicion)
coldata$condition <- factor(coldata$condition)
rownames(coldata) <- samples$Muestra
head(coldata)
dds <- DESeqDataSetFromTximport(txi, coldata, ~condition)
dds <- DESeq(dds)
resultsNames(dds)
res <- results(dds)
head(res)
plotMA(res)
saveRDS(res, "res_dseq2.rds")
```

### Ejercicio para ver como se calcula el log2foldchange

```
cts <- counts(dds, normalized=T)
head(cts)
cts['ENSG00000008735',]
x.HBR <-cts['ENSG00000008735',1:3]
x.HBR
mh <- mean(x.HBR)
mh 

x.UHR<-cts['ENSG00000008735',4:6]
x.UHR
mu <- mean(x.UHR)
mu

h <- log2(mh)
h
u <- log2(mu)
u

lfc_u_h <- u - h
lfc_u_h

log2(mu/mh)
res['ENSG00000008735',]
```

Como filtrar nuestra tabla de resultados para tener solo los DEGs significativos:

```
degs<-subset(res, (!is.na(res$padj) & 
                     res$pvalue<0.05 & 
                     baseMean>=50 & res$padj < 0.05 & 
                     abs(res$log2FoldChange)>1))
```

Como hacer un heatmap de nuestros resultados:
```
library (pheatmap)
top <- degs[order(degs$pvalue),]
myTpm <- subset(table.out, rownames(table.out) %in% rownames(top[1:10,]) )
dim(myTpm)
log2mat <- log2(myTpm)
my_hmap <- pheatmap(log2mat,
                    main="DEGs UHR vs HBR")


myTpm <- subset(table.out.names, table.out.names$gene_id %in% rownames(top[1:10,]))
dim(myTpm)
head(myTpm)
mat <- myTpm[,-c(1:2)]
rownames(mat) <- myTpm$gene_name
log2mat <- log2(mat)
my_hmap <- pheatmap(log2mat,
                    main="DEGs UHR vs HBR")
```

## Paso 4. usar EnrichR

EnrichR es un programa que te permite consultar múltiples bases de datos a la vez donde puedes ver que vías de señalización o rutas metabólicas están sobrerepresentadas o enriquecidas en un conjunto de genes en particular.

https://maayanlab.cloud/Enrichr/

EnrichR no se puede descargar, es un programa que tiene sólo existe en su propio sitio web, pero existe un paquete de R que nos permite conectarnos a la página web de EnrichR y ejecutarlo desde nuestra computadora.

https://cran.r-project.org/web/packages/enrichR/vignettes/enrichR.html

```
# si no estuviera instaldado lo puedes instalar con el siguiente comando:
#install.packages("enrichR")

# cargamos el paquete en nuestra sesión
library(enrichR)
```

Lo primero ahora es que checar que la página de EnrichR esté respondiendo

```
websiteLive <- getOption("enrichR.live")
```

EnrichR tienen bases de datos no sólo para humanos, con el siguiente código escogemos la base de datos para homo sapiens. 

```
if (websiteLive) {
  listEnrichrSites()
  setEnrichrSite("Enrichr") # Human genes
}
```
Ahora queremos saber que bases de datos tiene EnrichR disponibles

```
if (websiteLive) dbs <- listEnrichrDbs()
View(dbs)
```

Veamos cuáles están actualizadas a 2025
```
grep("2025",dbs$libraryName,value=T)
```

Seleccionamos un par de bases de datos para nuestro ejercicio

```
misDBS <- c("GO_Biological_Process_2025","WikiPathway_2024_Human")
```

Vamos a hacer una prueba con unos genes de ejemplo

```
if (websiteLive) {
  enriched <- enrichr(c("Runx1", "Gfi1", "Gfi1b", "Spi1", "Gata1", "Kdr"), misDBS)
}
```

Para ver los resultados, podemos checar individualmente los resultados de cada base de datos:

```
if (websiteLive) head(enriched[["GO_Biological_Process_2023"]])
if (websiteLive) head(enriched[["WikiPathway_2023_Human"]])
```

Ahora vamos a hacer el mismo ejercicio con los genes que salieron diferencialmente expresados de DESeq2

El primer paso es ponerle los nombres de los genes a nuestra tabla de resultados de DESeq2

```
topNombres <- merge(as.data.frame(top),geneId_geneName,by.x=0,by.y="gene_id")
```

Ahora tomamos los nombres de los genes y los analizamos con EnrichR

```
if (websiteLive) {
  enriched <- enrichr(topNombres$gene_name, misDBS)
}
```
Repetimos la exploración en cada base de datos

```
if (websiteLive) head(enriched[["GO_Biological_Process_2023"]])
if (websiteLive) head(enriched[["WikiPathway_2023_Human"]])
```

Graficamos los resultados de la primera base de datos

```
if (websiteLive) {
  plotEnrich(enriched[[1]], showTerms = 20, numChar = 40, y = "Count", orderBy = "P.value")
}
```

Para guardar nuestra tabla de resultados hacemos lo siguiente:

```
write.table(enriched[["WikiPathway_2023_Human"]], 
            file="enriched_WikiPathways_2023.tsv", sep="\t", 
            quote=F, 
            col.names=T,
            row.names=F)
```


GSEA

https://www.youtube.com/watch?v=Mi6u4r0lJvo
