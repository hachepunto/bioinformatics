
 ## Ejercicio de expresión diferencial a partir de archivos de cuantificación de Kallisto usando tximport y DESeq2:
 
 ### Objetivos:
 1. una matriz de expresión normalizada con los nombres y los ids de los genes
 2. tabla de genes diferencialmente expresados 

 ### Pasos:
 1. Instalar las herramientas que vamos a utilizar: BUStoolsR, tximport y DESeq2
 2. Usar tximport para integrar los archivos de cada muestra individual (a nivel de transcrito) en una sola matriz a nivel de gen. Tximport es una función que toma a) un archivo de referencia con los ids de los transcritos y el id del gene al que pertenecen, y b) los archivos de expresión.
    1. cargar nuestros datos de expresión
    2. generar archivo de referencia a partir del siguiente archivo:
 https://drive.google.com/file/d/1CIRVrYvNxy0Odzyr7yrVs9My82nZ7E2J/view?usp=sharing
    3. correr tximport con la referencia y nuestros datos de kallisto

---

Paso 1: instalar las herramientas que vamos a utilizar
```
install.packages("remotes")
remotes::install_github("lambdamoses/BUStoolsR")
BiocManager::install("tximport")
```


Mientras instalamos revisemos la documentación de tximport
https://bioconductor.org/packages/release/bioc/html/tximport.html

```
library(BUSpaRse)
library(tximport)
library(DESeq2)
```


Paso 2 
```
help("tximport")
```

Paso 2.1: cargar nuestros datos de expresión

Cargamos el archivo con los nombres de las muestras y las rutas a los archivos de expresión generados por Kallisto. El archivo sample_sheet.tsv debe tener las columnas: Muestra, Condición y Archivo separado por tabs.

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

```
myIDS <- tr2g_gtf("~/Dropbox/References/Homo_sapiens.GRCh38.104.chr22.gtf",
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
table.out.names <- merge(myNewIds,table.out,by.x='gene',by.y=0)
dim(table.out.names)
head(table.out.names)
write.table(table.out.names, 
            file="exprTable.tsv", sep="\t", 
            quote=F, 
            col.names=NA)
```

Paso 3: Expresión diferencial con DESeq2

```
sampleTable <- data.frame(condition = samples$Condicion)
rownames(sampleTable) <- samples$Muestra
head(sampleTable)
dds <- DESeqDataSetFromTximport(txi, sampleTable, ~condition)
dds <- DESeq(dds)
resultsNames(dds)
res <- results(dds)
head(res)
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

