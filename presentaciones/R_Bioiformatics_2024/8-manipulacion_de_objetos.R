################################################################################
### Introducción a R                                                         ###
###    __  ___          _           __         _  __                         ###
###   /  |/  /__ ____  (_)__  __ __/ /__ _____(_)/_/ ___                     ###
###  / /|_/ / _ `/ _ \/ / _ \/ // / / _ `/ __/ / _ \/ _ \                    ###
### /_/  /_/\_,_/_//_/_/ .__/\_,_/_/\_,_/\__/_/\___/_//_/                    ###
###      __           /_/    _     __                                        ###
###  ___/ /__   ___  / /    (_)__ / /____  ___                               ###
### / _  / -_) / _ \/ _ \  / / -_) __/ _ \(_-<                               ###
### \_,_/\__/  \___/_.__/_/ /\__/\__/\___/___/                               ###
###                    |___/                                                 ###
### Instituto Nacional de Medicina Genómica                                  ###
### Enero 2024                                                               ###
### Hugo Tovar <hatovar@inmegen.gob.mx>                                      ### 
################################################################################

## INTRODUCCIÓN ################################################################
# El sistema de indexación es una manera eficiente y flexible de acceder 
# selectivamente a elementos de un objeto. La indexación puede ser numérica, 
# lógica o por nombres. Para indexar se utilizan los corchetes o paréntesis 
# cuadrados *[ ]* y el símbolo de pesos *$*. Además, en esta sección aprenderemos el uso 
# de algunas otras funciones útiles como *which*, *unique*, y *str*. 

# Esta lección está dividida en las siguientes secciones:

## Clases de indexación ##
# A. Indexación numérica
# B. Indexación lógica
# C. Indexación por nombres

# D. Reemplazar elementos de un objeto

## Indexación por tipos de objetos ##
# E. Indexación de vectores
# F. Indexación de matrices
# G. Indexación de marcos de datos
# H. Indexación de listas


### A. INDEXACIÓN NUMÉRICA #####################################################

# Supongamos que tenemos un vector con 20 muestras de 4 genes

genes <- rep(paste("gen", c("a", "b", "c", "d"), sep="_"), each=5)
genes

class(genes)
length(genes)

# Supongamos ahora que tenemos un vector con los niveles de expresión para
# cada muestra

expression <- c(8.0766242,  9.8493313,  2.9028278, 10.0433943,  0.1470901, 
  12.5288041, 10.6120501, 14.6478501,  8.2003356, 17.9935623, 12.4214381, 
  18.3749778, 24.0950527, 19.3236943, 15.5498672, 22.0520207, 28.9908186, 
  17.5659344, 26.0387389, 14.1152262)
expression
class(expression)
length(expression)



# Se utiliza el numero del elemento que se quiere extraer entre corchetes *[ ]*. 

genes[2]
genes[10]

expression[2]
expression[10]

# También se puede extraer más que un solo numero

genes[c(7,7,7)]
expression[c(2,5,7)]


## IMPORTANTE: en la indexación numérica se puede utilizar el signo de menos *-*
## para extraer todos los elementos excepto aquellos que se indican entre corchetes

genes[2] # Esto extrae el segundo elemento
genes[-2] # Esto extrae todos los elementos excepto el segundo

expression[c(2,5,7)] # Esto extrae los elementos 2, 5 y 7
expression[-c(2,5,7)] # Esto extrae todo, excepto los elementos  2, 5 y 7



### B. INDEXACIÓN LÓGICA #######################################################
# Se utiliza valores TRUE y FALSE entre corchetes *[]* para extraer elementos. 
# Esto extrae los elementos que corresponden a TRUE.

expression
expression < 15 # Esto genera un vector lógico donde TRUE son valores de *expression* < 15

expression[expression<15] # Esto extrae los elementos de *expression* que son menores que 15

# Podríamos salvar ese vector lógico en un objeto

menoresde15 <- expression < 15
menoresde15

# Y usarlo para subsetear otro vector cualquiera del mismo tamaño

genes[menoresde15]

# lo que es lo mismo que 

genes[expression<15] 

# otro ejemplo

genes=="gen_b"            
expression[genes=="gen_b"] 

# La función *which* nos puede indicar qué número de elemento es verdadero:

which(genes=="gen_b")
which(expression<15)
which(menoresde15)

# También se pueden utilizar condiciones más complejas

expression[genes=="gen_b" | genes=="gen_c"] 

expression[genes=="gen_b" & genes=="gen_c"] 

expression[genes=="gen_b" & expression>15] 

expression[expression<15 & expression>25]

expression[expression>15 & expression<25]

expression[expression<15 | expression>25]


### D. INDEXACIÓN POR NOMBRES ##################################################
# Se utiliza nombres de elementos entre corchetes *[]* para extraerlos                  

# Para este tipo de indexación, los elementos deben tener nombres:     

expression
names(expression) <- letters[1:length(expression)]
expression



genes
names(genes) <- letters[length(expression):1] # Aquí es mejor no utilizar nombres repetidos
genes

expression["p"] # Extrae el valor en *expression* 
                # que tiene el nombre "p"

genes["l"] # Extrae el nombre del gen en *genes*
           # que tiene el nombre "l"


# También se pueden extraer varios elementos por nombre

expression[c("o", "n", "g")]

# ¿Cómo estraeríamos los que *NO* son "o", "n" ni "g"

# Dos maneras de hacerlo sería

expression[!(names(expression) %in% c("o", "n", "g"))]
expression[-(which(names(expression) %in% c("o", "n", "g")))]

### E. REEMPLAZAR VALORES EN UN OBJETO #########################################
# El sistema de indexación nos permite reemplazar o re-escribir los valores de
# elementos particulares dentro de un objeto

genes
genes[c(1,4,18)]

expression
expression[c("o", "n", "g")]

# reemplazo
genes[c(1,4,18)] <- "gen_x"
genes

expression[c("o", "n", "g")] <- c(100, 100, 100)
expression


# Adición de un elemento
genes <- c(genes, "gen_y")
genes

expression <- c(expression, x = 0)
expression

### F. INDEXACIÓN DE VECTORES ##################################################
# La indexación de vectores la practicamos ya en tipos de indexación. Los valores
# que quieren extraerse van entre corchetes.


### G. INDEXACIÓN DE MATRICES ##################################################

# Abramos un archivo de datos (data_carbondioxideyearlyemissions.txt) para 
# practicar indexación de matrices. Esto contiene datos de emisiones de CO2
# por país (columnas) por año (filas).

CO2 <- read.table(file = "Datasets/data_carbondioxideyearlyemissions.txt",
                  header = TRUE,
                  row.names = 1,
                  sep = "\t")

dim(CO2)
class(CO2) # La función *read.table* siempre produce un marco de datos

# Transformemos el marco de datos a una matriz

CO2 <- as.matrix(CO2)
class(CO2)
head(CO2)

# La manera más común de indexar matrices es por fila y por columna.

CO2[150, 30] # Esto extrae el valor en la fila 150 y la columna 30 de la matriz

rownames(CO2)[150]
colnames(CO2)[30]

## IMPORTANTE: siempre las filas se especifican primero, 
## seguido de una coma, y finalmente las columnas. Como coordenadas.

CO2[200, 45]
CO2[45, 200]
CO2[240, 155]


# También se pueden extraer varias columnas y/o filas al mismo tiempo

CO2[c(200, 45, 240), c(45, 200, 155)]


## IMPORTANTE: Cuando queremos todos los elementos de una fila o una columna,
## simplemente no especificamos nada. Por ejemplo:

CO2[,100] # Esto extrae todos los elementos de la columna numero 100
CO2[240, ] 
CO2[10, ] 

CO2[-10, ] # Esto extrae todos los elementos excepto la fila numero 10
CO2[, -100] 
              

# Las matrices también se pueden indexar por los nombres de las filas o las columnas

CO2[2010, ] # Esto genera un error porque no hay 2010 filas
CO2["2010", ] # Esto NO genera un error porque estamos haciendo una 
              # indexación de la fila llamada "2010" 

CO2["2010", "Mexico"] 
                      
# Como han cambiado las emisiones de CO2 en México?

years <- as.numeric(rownames(CO2))

plot(CO2[, "Mexico"] ~ years, col="forestgreen")


# Como cambiaron las emisiones de CO2 en México en el siglo 21?

plot(CO2[years>2000, "Mexico"] ~ years[years>2000], col="forestgreen", type="b")

  
# Como se comparan las emisiones en México con las de EEUU y Ecuador

plot(CO2[, "United.States"]~years, col="navy", type="l", lwd=4, ylab="Emisiones")

points(CO2[, "Mexico"]~years, col="forestgreen", type="l", lwd=4)
points(CO2[, "Ecuador"]~years, col="gold", type="l", lwd=4)

# Podemos arruinar los datos cambiando algunos valores a 0

CO2[years>1950, "Mexico"] <- 0

plot(CO2[, "Mexico"] ~ years, col="forestgreen", type="b")

## IMPORTANTE: las matrices también pueden indexarse por numero de elemento, no
## solamente por fila y columna

M <- matrix(letters[-26], ncol=5)
colnames(M) <- paste("var", 1:ncol(M), sep="_")

M
class(M)
dim(M)

# Estos pares comandos extraen el mismo elemento

M[2, 2] 
M[7]

M[5,5]
M[25]




### H. INDEXACIÓN DE MARCOS DE DATOS ###########################################
# La indexación de marcos de datos es muy parecida a la de matrices excepto por
# estos dos aspectos:

# 1. Los marcos de datos no pueden indexarse por numero de elemento, solo 
# por filas y columnas

M.df <- as.data.frame(M)

class(M)
M[2,2]
M[7]

class(M.df)
M.df[2,2]
M.df[7]


# 2. Las columnas (variables) en un marco de datos también se pueden indexar
# por nombre utilizando el símbolo *$* después del nombre del objeto. Esto no 
# se puede hacer en las matrices:

colnames(M)

M.df[,"var_2"]
M.df$var_2

M[,"var_2"]
M$var_2

# Esto abre la base de datos "iris" que esta en el paquete "datasets". 
# (https://en.wikipedia.org/wiki/Iris_flower_data_set).

data(iris)
help(iris)

class(iris)
dim(iris)

str(iris) # La función *str* reporta un resumen de la estructura de un objeto

iris[,1:4] # Estas primeras columnas son variables morfológicas
iris[,5] # Esta ultima columna  tiene nombres de especies


morpho <- iris[,1:4]

species <- iris$Species

class(species)
levels(species)
species

species <- as.vector(species)
species
class(species)
unique(species) # Crea una lista de valores únicos
table(species)

# Grafico de la longitud del sépalo y longitud del pétalo de I. setosa y 
# I. virginica

plot(morpho$Sepal.Length ~ morpho$Sepal.Width, type="n")

points(morpho$Sepal.Length[species=="setosa"] ~ 
    morpho$Sepal.Width[species=="setosa"], col="gold")
    
points(morpho$Sepal.Length[species=="versicolor"] ~ 
    morpho$Sepal.Width[species=="versicolor"], col="navy")

points(morpho$Sepal.Length[species=="virginica"] ~ 
    morpho$Sepal.Width[species=="virginica"], col="red")



### I. INDEXACIÓN DE LISTAS ####################################################

L1 <- list(c(0.01, 3.1), c(0.02, 4.0, 0.1), c("a"), c(0.01, 2.9), c(0.03), 
    c(0.04, 3.4, 8.2, 1.6)) 
    
class(L1)
L1

length(L1)
str(L1)

names(L1) <- paste("elem", 1:length(L1), sep="_")
L1

L1.1 <- L1[1] # *[]* extrae el primer elemento de la lista como una lista
L1.1
class(L1.1)

L1.1 <- L1[[1]] # *[[]]* Extrae el primer elemento de la lista como el vector
                # que contiene
L1.1
class(L1.1)


L1[-1]
L1[1:3]

L1["elem_1"] # En listas, también se puede hacer indexación por nombres
class(L1["elem_1"])

L1[["elem_1"]]
class(L1[["elem_1"]])
 
L1$elem_1 
class(L1$elem_1)

# Otras manipulaciones:

L1[2:4][1]
L1[1:3][-1]

L1[[1]]
L1[[1]][2]

L1[[1]]
L1[[1]][1]

L1[[1]]<-3
L1

L1[[2]]
L1[[2]] > 2

L1[[2]] [L1[[2]]<1]
