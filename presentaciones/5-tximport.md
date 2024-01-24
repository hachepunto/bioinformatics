
## Ejercicio de expresión diferencial a partir de archivos de cuantificación de Kallisto usando tximport y DESeq2:
 
### Objetivos:
1. obtener una matriz de expresión normalizada con los nombres y otra con los ids de los genes
2. obtener la lista de genes diferencialmente expresados 

### Pasos:
1. Crear un archivo con la información de nuestras muestras
2. Usar tximport para integrar los archivos de cada muestra individual (a nivel de transcrito) en una sola matriz a nivel de gen. Tximport es una función que toma a) un archivo de referencia con los ids de los transcritos y el id del gene al que pertenecen, y b) los archivos de expresión.
   1. crear un archivo con la información de nuestras muestras
   2. cargar nuestros datos de expresión
   3. cargar nuestro archivo de referencia
   4. correr tximport con la referencia y nuestros datos de kallisto
3. Utilizar DESeq2 para identificar genes diferencialmente expresados
---
Paso 0: Abrir Rstudio en drona en un navegador
```
drona.inmegen.gob.mx:8787 
```

Paso 1: crear el archivo con la información de nuestras muestras

En la terminal de Rstudio (ojo: no la consola) ejecuta los siguientes comandos:

```
ls ~/datos.taller/salida_kallisto_*/abundance.tsv | cut -d"/" -f5 | cut -d"_" -f3-4 > ids.txt
ls ~/datos.taller/salida_kallisto_*/abundance.tsv | cut -d"/" -f5 | cut -d"_" -f3 > condicion.txt
ls ~/datos.taller/salida_kallisto_*/abundance.tsv > rutas.txt
paste ids.txt condicion.txt rutas.txt > mis_muestras.tsv
```

Confirma que en el archivo mis_muestras.tsv tengas 3 columnas: 1) id de la muestra, 2) el tipo o la condicion de la muestra y 3) la ruta absoluta donde se encuentran los archivos de abundancias para cada muestra (6 en total) generados por kallisto.

```
more muestras.tsv
```


Paso 1: Tximport 

https://bioconductor.org/packages/release/bioc/html/tximport.html

Para empezar a crear un script con todos los pasos que vamos a ejecutar, abran en Rstudio un Rscript:
File -> New File -> Rscript

Hagan click en el icono del diskette para guardar el archivo y ponganle de nombre: ejercicio_deseq2.R

De ahora en adelante todos los pasos que hagamos los copian primero en su Rscript y desde ahi los ejecutan en la consola, igual como lo hicieron en las sesiones pasadas de R.

Cargamos las bibliotecas que vamos a utilizar:

```
library(tximport)
library(DESeq2)
```

Empecemos por consultar la ayuda de tximport para saber que parámetros recibe la función.
```
help("tximport")
```


Paso 1.2: cargar nuestros datos de expresión

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
