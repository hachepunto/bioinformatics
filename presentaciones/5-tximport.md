
## Ejercicio de expresión diferencial a partir de archivos de cuantificación de Kallisto usando tximport y DESeq2:
 
### Objetivos:
1. obtener una matriz de expresión normalizada con los nombres y otra con los ids de los genes
2. obtener la lista de genes diferencialmente expresados 

### Pasos:
1. Usar tximport para integrar los archivos de cada muestra individual (a nivel de transcrito) en una sola matriz a nivel de gen. Tximport es una función que toma a) un archivo de referencia con los ids de los transcritos y el id del gene al que pertenecen, y b) los archivos de expresión.
   1. cargar nuestros datos de expresión
   2. cargar nuestro archivo de referencia
   3. correr tximport con la referencia y nuestros datos de kallisto
3. Utilizar DESeq2 para identificar genes diferencialmente expresados
---
Paso 0: Abrir Rstudio en drona
```
drona.inmegen.gob.mx:8787 
```

Paso 1: Ver que es tximport

https://bioconductor.org/packages/release/bioc/html/tximport.html

Cargamos las bibliotecas que vamos a utilizar:

```
library(tximport)
library(DESeq2)
```


Paso 2:

Empecemos por consultar la ayuda de tximport para saber que parámetros recibe la función.
```
help("tximport")
```

Paso 2.1: cargar nuestros datos de expresión

Cargamos el archivo con los nombres de las muestras y las rutas a los archivos de expresión generados por Kallisto. El archivo sample_sheet.tsv debe tener las columnas: Muestra, Condicion y Archivo separado por tabs. 

Notas: 
1. es importante no poner acentos dentro de sus archivos.
2. si tu archivo no está separado por tabs puedes usar otro separador en el argumento sep, por ejemplo sep="," o sep=";"
3. usamos header=T cuando nuestro archivo tiene encabezado, en este caso los nombres de las columnas. (T=True)

```
samples <- read.table("sample_sheet.tsv",sep="\t",header=T)
```

con este comando inspeccionamos los primeros renglones

```
head(samples)
```

La función tximport espera un vector con las rutas de los archivo de expresión con el atributo names que corresponda al nombre de la muestra

```
files <- as.vector(samples$Archivo)
names(files) <- samples$Muestra 
head(files)
```

Paso 2.2: generar archivo de referencia
Nota: BUSpaRse tiene otras herramientas para crear la tabla que necesitamos a partir de otros formatos (ej. archivo fasta o base de datos de Ensembl que se puede acceder dentro de R)

```
myIDS <- tr2g_gtf("Homo_sapiens.GRCh38.104.chr22.gtf",
                  get_transcriptome = F)
```

exploramos la tabla que acabamos de generar ...

```
head(myIDS)
sum(is.na(myIDS$gene_name))
length(myIDS$gene_name)
```

nuestro archivo de referencia solo necesita estas dos columnas:

```
tx2gene <- myIDS[,c("transcript","gene")]
head(tx2gene)
```
 
Paso 2.3: ejecutar tximport

```
txi <- tximport(files, 
                type = "kallisto", 
                tx2gene = tx2gene)
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
myIDS$gene_name <- ifelse(is.na(myIDS$gene_name), myIDS$gene, myIDS$gene_name)
myNewIds <- unique(myIDS[,2:3])
dim(myNewIds)
head(myNewIds)

table.out.names <- merge(myNewIds,table.out,by.x='gene',by.y=0)
dim(table.out.names)
head(table.out.names)
write.table(table.out.names, 
            file="exprTable.tsv", sep="\t", 
            quote=F, 
            col.names=T,
            row.names=F)
```

Paso 3: Expresión diferencial con DESeq2  https://bioconductor.org/packages/release/bioc/vignettes/DESeq2/inst/doc/DESeq2.html

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
```

Ejercicio para ver como se calcula el log2foldchange

```
cts <- counts(dds, normalized=T)
head(cts)
cts['ENSG00000008735.14',]
x.HBR <-cts['ENSG00000008735.14',1:3]
x.HBR
mh <- mean(x.HBR)
mh 

x.UHR<-cts['ENSG00000008735.14',4:6]
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


myTpm <- subset(table.out.names, table.out.names$gene %in% rownames(top[1:10,]))
dim(myTpm)
head(myTpm)
mat <- myTpm[,-c(1:2)]
rownames(mat) <- myTpm$gene_name
log2mat <- log2(mat)
my_hmap <- pheatmap(log2mat,
                    main="DEGs UHR vs HBR")
```

GSEA

https://www.youtube.com/watch?v=Mi6u4r0lJvo
