################################################################################
### Introducción a R                                                         ###
###    ___   __       _                                                      ###
###   / _ | / /  ____(_)___  __ __                                           ###
###  / __ |/ _ \/ __/ / __/ / // /                                           ###
### /_/ |_/_.__/_/ /_/_/    \_, /                                            ###
###                        /___/                                             ###
###   ___ ___ _____ ________/ /__ _____                                      ###
###  / _ `/ // / _ `/ __/ _  / _ `/ __/                                      ###
###  \_, /\_,_/\_,_/_/  \_,_/\_,_/_/                                         ###
### /___/                                                                    ###
### Instituto Nacional de Medicina Genómica                                  ###
### Enero 2024                                                               ###
### Hugo Tovar <hatovar@inmegen.gob.mx>                                      ### 
################################################################################


### DIRECTORIO DE TRABAJO ###################################################

# El directorio de trabajo (working directory) es una carpeta la computadora 
# donde R escribe o lee archivos de manera pre-determinada.

# Para conocer cual es el directorio de trabajo actual:

getwd()

# Para cambiar el directorio de trabajo:
# setwd(dir="dirección a una carpeta en tu computadora"), por ejemplo:

setwd(dir="/home/alumnoX/R_Bioiformatics_2024")

getwd() # Confirma el cambio del directorio de trabajo

# Lista los archivos y carpetas en el directorio de trabajo:

list.files()
dir()


### PRINCIPALES FUNCIONES PARA ABRIR Y GUARDAR ARCHIVOS #####################

# 1. read.table: abre marco de datos 
# 2. load: abre cualquier objeto de R
# 3. source: abre un 'script' de R

# 4. write.table: guarda un marco de datos
# 5. save: guarda cualquier objeto de R
# 6. saveRDS: guarda objetos uno por uno



### ABRIR UNA TABLA DE DATOS ################################################

help(read.table)

## PRINCIPALES ARGUMENTOS:
# 1. file: El nombre del archivo a abrir - y su dirección si el archivo no está
#    en el directorio de trabajo.
# 2. header: TRUE o FALSE. TRUE si la primera fila del archivo representa 
#    los nombres de las columnas.
# 3. sep: El caracter que se usa para separar valores, más frecuentemente: "\t"
#    o ",". 


expr.data <- read.table(file = "Datasets/Example_expression_set.txt", 
                        header = TRUE, 
                        sep = "\t")


## IMPORTANTE: *read.table* siempre abre datos como un marco de datos

class(expr.data)
names(expr.data)

summary(expr.data)
head(expr.data)

### GUARDAR UNA TABLA DE DATOS ##############################################

help(write.table)

## PRINCIPALES ARGUMENTOS:
# 1. x: El objeto de R (marco de datos o matriz) a grabar en un archivo
# 2. file: El nombre del archivo a crear - y su dirección si uno quiere el 
#    archivo en otra carpeta que no es el directorio de trabajo.
# 4. sep: El caracter que se usa para separar valores, más frecuentemente: "\t"
#    o ",". 

# *expr.data* Este es el marco de datos que habíamos creado

dir("Datasets")

write.table(x = expr.data, 
            file = "Datasets/expr_data.txt", 
            row.names = FALSE, 
            sep = "\t")

list.files("Datasets/") # La lista actualizada de archivos en el directorio 


# Podemos volver a abrir el archivo que creamos:

expr.data2 <- read.table(file = "Datasets/expr_data.txt", 
                          header = TRUE, 
                          sep = "\t")
       
identical(expr.data, expr.data2)
    
    
### GUARDAR OBJETOS BINARIOS DE R  ##############################################
    
# Algunas veces es conveniente guardar objetos de R en un documento binario. Ya sea para:
# 1) Cuando no es eficiente guardar datos en formato de texto.
# 2) Cuando es más conveniente guardar distintos objetos de R juntos.
# 3) Con datos numéricos, con la intención de no perder precisión cuando se convierte a texto.

# La función principal para guardar objetos de R en binario es *save*

help(save)

## PRINCIPALES ARGUMENTOS:
# 1. '...': lista de objetos de R a guardar.
# 2. file: El nombre del archivo a crear - y su dirección si uno quiere el 
#    archivo en otra carpeta que no es el directorio de trabajo.

save(expr.data, expr.data2, file ="Datasets/expr_datas.RData" )
dir("Datasets")

# A veces, cuando tienes muchos objetos, es conveniente guardar todo el ambiente de trabajo. La función
# de atajo de *save* para hacer esto es *save.image*.

save.image(file = "Datasets/R_bioinformatics.RData")


# limpiemos el ambiente de R

ls()
rm(list = ls())

# cargamos binario con dos objetos

load("Datasets/expr_datas.RData")
ls()

# cargamos binario con todo el ambiente de trabajo

load("Datasets/R_bioinformatics.RData")
ls()


# Comúnmente es conveniente guardar un solo objeto en un solo archivo. Para 
# ello usamos *saveRDS* y *readRDS* para cargarlos en nuestro ambiente.

## PRINCIPALES ARGUMENTOS:
# *saveRDS*
# 1. object: un objeto de R de nuestro ambiente
# 2. file: El nombre del archivo a crear - y su dirección si uno quiere el 
#    archivo en otra carpeta que no es el directorio de trabajo.

# *readRDS*
# 1. file: Archivo que contiene el objeto a leer. Debemos asignas a un objeto
#    el resultado de esta función.

saveRDS(expr.data, file = "Datasets/expr_data.RDS")

readRDS("Datasets/expr_data.RDS") # esto no crea un objeto en nuestro ambiente.

saved_rds <- readRDS("Datasets/expr_data.RDS")


