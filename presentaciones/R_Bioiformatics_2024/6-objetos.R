################################################################################
### Introducción a R                                                         ###
###   ____  __     _     __                                                  ###
###  / __ \/ /    (_)__ / /____  ___                                         ###
### / /_/ / _ \  / / -_) __/ _ \(_-<                                         ###
### \____/_.__/_/ /\__/\__/\___/___/                                         ###
###          |___/                                                           ###
### Instituto Nacional de Medicina Genómica                                  ###
### Enero 2024                                                               ###
### Hugo Tovar <hatovar@inmegen.gob.mx>                                      ### 
################################################################################


### QUE ES UN OBJETO Y COMO CREARLO #########################################

# Un objeto en R es un pedazo de memoria que contiene información.
# Frecuentemente esa información son datos.
# Los objetos pueden tener varios tipos de datos y pueden ser de varias clases.

# La manera más sencilla de crear un objeto es utilizando el operador *<-*

x <- 10
x

# Esto crea un objeto llamado *x* que contiene el valor 10

x <- c(10, 5, 2)
x

# Esto RE-ESCRIBE el objeto *x* y le asigna una secuencia de 3 valores


# Otra manera de crear un objeto es con la función *assign*

assign(x = "x2", value = c(10, 5, 2))
x2

identical(x, x2)

### TIPOS DE DATOS EN OBJETOS ###############################################

# Hay 4 tipos de datos comúnmente utilizados en R:
# 1. Numéricos - números
# 2. Caracteres - texto
# 3. Lógicos - verdadero/falso
# 4. Valores especiales


## 1. NUMÉRICOS ##
# Supongamos que tenemos los factores de cambio de 5 famosos genes relacionados  
# con cáncer:

logFCh <- c(1, 0, 0, 6, -2)
logFCh

# La función *mode* nos dice el tipo de datos contenidos en el objeto *logFCh*

mode(x = logFCh)

## 2. CARACTERES ##
# Supongamos que tenemos los nombres de esos 5 genes:

genes <- c("TP53", "MYC", "BRCA1", "BRCA2", "ATM")
genes

mode(genes)

# IMPORTANTE: Tomar en cuenta que los valores de caracteres siempre van entre 
# comillas. Esto generaría un error:

genes <- c(TP53, MYC, BRCA1, BRCA2, ATM)


## 3. LÓGICOS ##
# Supongamos ahora que el log Fold Change de cada gen cambió o no 
# respecto a un control:

increm <- c(TRUE, FALSE, FALSE, TRUE, TRUE)
increm

mode(increm)

# IMPORTANTE: Tomar en cuenta que valores lógicos NO van entre comillas y se 
# escriben en mayúsculas


## 4. VALORES ESPECIALES ##
# 4.1. NA: valor perdido, no disponible (not available)

x <- NA
x
is.na(x)

# 4.2. Inf: infinito

100/0

-100/0

100-Inf

# 4.3. NaN: no es un número (not a number) 

Inf-Inf

# 4.4. NULL: nulo - usado para indicar un valor de argumento no especificado

x <- NULL
x
is.null(x)




### CLASES DE OBJETOS #######################################################

# 1. Vectores: 1 dimensión - numéricos, caracteres, lógicos
# 2. Factores: 1 dimensión - niveles de un factor
# 3. Matrices: 2 dimensiones
# 4. Arreglos: n dimensiones
# 5. Data frames (marcos de datos): 2 dimensiones
# 6. Lista
# 7. Otras clases

## IMPORTANTE: Cada objeto tiene ATRIBUTOS que definen como funciona en R ##



### 1. VECTORES ################################################################
# Vectores representan una secuencia lineal de valores, cada valor con una 
# posición en la secuencia:

logFCh
genes
increm

# CLASE es el principal atributo de un vector

class(logFCh)
class(genes)
class(increm)

# LONGITUD es otro de los principales atributos de un vector

length(logFCh)
length(genes)
length(increm)

# NOMBRES es otro atributo de un vector

names(logFCh)

# Para crear nombres en este vector:

names(logFCh) <- paste("gene", seq(1,length(logFCh)), sep = "_")
names(logFCh)
logFCh

# Alternativamente:

genes
names(logFCh) <- genes
logFCh

# También:

increm
names(increm)

names(increm) <- names(logFCh) # Utiliza los nombre de un objeto para otro
names(increm)
increm

identical(x=names(increm), y=names(logFCh))


## IMPORTANTE: Los vectores pueden tener SOLO un tipo de datos: numéricos, 
#              caracteres o lógicos. NUNCA UNA COMBINACIÓN.

x <- c(1,2,3)
x
class(x)

x2 <- c(1,2,3,"a")
x2
class(x2)


### 2. FACTORES ################################################################
# Factores también representan una secuencia linear de valores, pero están 
# diseñados para ser NIVELES DE UNA VARIABLE CATEGÓRICA. 

# Por ejemplo, supongamos que tenemos el estado de expresión diferencial de algunos genes:

diff <- c("down", "down", "equal", "up", "down", "equal", "equal", "down")
diff
length(diff)
class(diff)
mode(diff)

diff2 <- factor(diff)
diff2
length(diff2)
class(diff2)
mode(diff2)

identical(diff, diff2)

# Un atributo importante de factores es sus NIVELES (LEVELS)

levels(diff2)


# IMPORTANTE: la clase frecuentemente afecta como funciones procesan objetos.
# Por ejemplo:

plot(diff)
plot(diff2)


### 3. MATRICES ################################################################
# Las matrices son parecidas a vectores, pero tienen dos dimensiones: FILAS Y 
# COLUMNAS.

# Supongamos que tenemos los niveles de expresión de 5 genes (filas) en 
# muestras distintas (columnas):

expr.M <- matrix(1:(5*4), nrow = 5, ncol = 4)
expr.M

class(expr.M)


# la función *matrix* tiene otro argumento *byrow* con el valor pre-determinado
# de *FALSE*. ¿Qué pasa si lo cambiamos a *TRUE*?

expr.M2 <- matrix(1:(5*4), nrow=5, ncol = 4, byrow = TRUE)
expr.M2

?matrix


# Utilicemos valores un poco más realistas 

expr.M <- matrix(rpois(5*4, 10), nrow=5, ncol=4)
expr.M


# Al igual que vectores, matrices tienen LONGITUD

length(expr.M)

# Además, matrices también tienen DIMENSIONES

dim(expr.M)

nrow(expr.M)
ncol(expr.M)


# Cada observación en una matriz puede tener NOMBRES

names(expr.M)
names(expr.M) <- paste("obs_", 1:length(expr.M), sep = "")
expr.M

# Más frecuentemente, se utilizan nombres solamente para columnas y filas

colnames(expr.M)
rownames(expr.M)

colnames(expr.M) <- paste(1:ncol(expr.M), ".CEL", sep="")
rownames(expr.M) <- genes
expr.M


## IMPORTANTE: Las matrices, como vectores,  pueden tener SOLO un tipo de datos: 
# numéricos, caracteres o lógicos. NUNCA UNA COMBINACIÓN.

expr.M2 <- matrix(sample(c(1:20, letters), 5*4), nrow=5, ncol=4)
expr.M2

class(expr.M2)
mode(expr.M2)


genes
logFCh

mixed.matrix <- cbind(genes, logFCh)
mixed.matrix
class(mixed.matrix)
mode(mixed.matrix)



### 4. ARREGLOS ################################################################
# Los arreglos son parecidos a matrices, pero tienen MÁS DE DOS DIMENSIONES. 
# Con tres dimensiones, es como dos matrices de las mismas dimensiones una
# detrás de otra (con filas y columnas alineadas).

logFCh.A <- array(rpois(5*4*2, 1), dim=c(5,4,2))
logFCh.A

mode(logFCh.A)
class(logFCh.A)

length(logFCh.A)
dim(logFCh.A)
dimnames(logFCh.A)

# Podemos poner nombres a cada elemento en cada dimensión

dimnames(logFCh.A) <- list(genes, paste(1:4, ".CEL", sep=""), c("days0", "days15"))
logFCh.A


### 5. Data frames #########################################################
# Los marcos de datos organizan variables (columnas) medidos para diferentes 
# observaciones (filas). De esta manera, CADA COLUMNA PUEDE TENER VALORES DE 
# TIPOS DISTINTOS (numéricos, caracteres, lógicos o factores).

genes
expr.M
increm

genes.code <- 1:length(genes)

expr.data <- data.frame(genes.code, genes, expr.M, increm)
expr.data

class(expr.data)

mode(expr.data$genes)
mode(expr.data$increm)

# IMPORTANTE: matrices y marcos de datos funcionan distinto!

expr.data2 <- as.matrix(expr.data)
expr.data2
class(expr.data2)

dim(expr.data)
dim(expr.data2)

length(expr.data)
length(expr.data2)

mode(expr.data)
mode(expr.data2)

names(expr.data)
names(expr.data2)


# Las columnas (variables) en un marco de datos deben todos tener la misma 
# longitud.

x <- c("a", "b")
y <- 1:5
z <- 1:6

x
y
z

length(x)
length(y)
length(z)

xy <- data.frame(x, y)

xz <- data.frame(x, z)

xz



### 6. LISTAS ##################################################################
# Las listas también pueden contener elementos de distintos tipos o clases, y NO
# necesitan tener la misma longitud.

x
class(x)

expr.M
class(expr.M)

diff
class(diff)

expr.data
class(expr.data)


random.list <- list(x, expr.M, diff, expr.data)

# Cada objeto se convierte en un elemento de la lista

random.list

# Algunos atributos de una lista:

class(random.list)
length(random.list)
dim(random.list)
names(random.list)

names(random.list) <- c("x", "expr.M", "diff", "expr.data")
random.list

# Conocer la estructura de una lista es muy útil:

str(random.list)


## IMPORTANTE: Muchas funciones utilizan listas para exportar resultados de 
# análisis.

x <- rnorm(100)
y <- 4 + 5*x + rnorm(100)

plot(y~x)

lm.res <- lm(y~x)
lm.res

str(lm.res)



### 7. OTROS ###################################################################
# Muchos análisis o funciones generan objetos de clases particulares. Pero, la 
# gran mayoría son construcciones de los objetos básicos que hemos
# revisado. Por ejemplo:

# Modelos lineales generan objetos de clase *lm*, pero son listas en su estructura 

class(lm.res)

# Sin embargo, el hecho de ser de clase *lm* hace que ciertas funciones manejen
# este objeto de maneras específicas a su clase.

plot(lm.res)

# Otra clase de objeto son árboles filogenéticos

install.packages("ape") # Esto instala un paquete llamado *ape*
library(ape) # Esto abre el paquete

# El paquete *ape* contiene un árbol filogenético de murciélagos

data(chiroptera)
class(chiroptera)

# A pesar de ser un objeto de clase *phylo*, este objeto tiene la estructura 
# de una lista

str(chiroptera)

# La función *plot* sabe que hacer cuando se le da un árbol filogenético

plot(chiroptera, show.tip.label=FALSE)


