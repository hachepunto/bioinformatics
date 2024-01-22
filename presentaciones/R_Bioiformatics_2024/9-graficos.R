################################################################################
### Introducción a R                                                         ###
###   _____      __ ____                                                     ###
###  / ___/_____/_// _(_)______  ___                                         ###
### / (_ / __/ _ `/ _/ / __/ _ \(_-<                                         ###
### \___/_/  \_,_/_//_/\__/\___/___/                                         ###
###                                                                          ###
### Instituto Nacional de Medicina Genómica                                  ###
### Enero 2024                                                               ###
### Hugo Tovar <hatovar@inmegen.gob.mx>                                      ### 
################################################################################

### INTRODUCCIÓN ###############################################################

# R ofrece una variedad increíble de opciones para construir gráficos. Escribe 
# este código en la consola para ver unas pocas opciones que son posibles:


# https://www.r-graph-gallery.com


# Esta presentación esta dividida en las siguientes secciones:

# A. Funciones gráficas de alto nivel (high-level functions) 
# B. Funciones gráficas de bajo nivel (low-level functions) 
# C. Parámetros gráficos modificados por la función *par* 
# D. Partir una ventana de gráficos
# E. Guardar gráficos como archivos 



### A. FUNCIONES GRÁFICAS DE ALTO NIVEL ########################################

# Las funciones gráficas de alto nivel se utilizan para crear gráficas, mientras
# que las de bajo nivel se utilizan para modificarlas o añadir elementos. 

data(iris)
str(iris)

## *plot* es una función genérica que sirve para hacer muchos tipos de gráficos.
# Una función genérica trabaja distinto dependiendo del tipo de argumentos que 
# se le da. Sin embargo, esta función se usa más frecuentemente para hacer 
# "scatterplots":  

plot(iris$Sepal.Length ~ iris$Sepal.Width)

plot(iris$Petal.Length ~ iris$Petal.Width)


# Existen muchos argumentos que pueden ser utilizados en la función *plot* y en 
# otras funciones para modificar figuras. Algunas de las más comunes son:

# type: cambia el tipo de grafico 

# pch: cambia la forma del símbolo
# cex: cambia el tamaño del símbolo
# col: cambia el color del símbolo
# bg: cambia el color del fondo del símbolo

# main: cambia el titulo principal
# xlab y ylab: cambian los títulos de los ejes
# cex.lab: cambia el tamaño del texto de los títulos de ejes
# cex.axis: cambia el tamaño del texto en los ejes

# las: controla la orientación del texto en el eje y
# bty: cambia el tipo de recuadro al rededor de los puntos 


plot(iris$Petal.Length ~ iris$Petal.Width, cex=3)

plot(iris$Petal.Length ~ iris$Petal.Width, cex=2, pch=21, col="black", bg="grey")

plot(iris$Petal.Length ~ iris$Petal.Width, cex=3, pch=21, col="black", bg="grey",
    main="Plot of Petal Width vs. Petals Length", xlab="Petal Width", 
    ylab="Petal Length", cex.lab=1.5, cex.axis=1.5, bty="l", las=1)



## Estas son otras funciones para gráficos comunes ##

# *boxplot* hace graficos de cajas

boxplot(iris$Sepal.Length)

boxplot(iris$Sepal.Length ~ iris$Species)

boxplot(iris$Sepal.Length ~ iris$Species, col="gold", horizontal=TRUE, las=1)

boxplot(iris$Sepal.Length ~ iris$Species, names=expression(italic("Iris setosa"), 
    italic("Iris versicolor"), italic("Iris virginica")), 
    xlab="Sepal length (cm)", col="gold", cex.lab=1.5, cex.axis=1.5, las=1)


# *hist* hace histogramas

hist(iris$Sepal.Length)

range(iris$Sepal.Length)

hist(iris$Sepal.Length, breaks=seq(min(iris$Sepal.Length), 
    max(iris$Sepal.Length), length.out=30), col="darkolivegreen", 
    border="white")

hist(iris$Sepal.Length, breaks=seq(min(iris$Sepal.Length), 
    max(iris$Sepal.Length), length.out=30), col="darkolivegreen", 
    border="white", xlab="Sepal Length", freq=FALSE)


# *pie* o *piechart* crea gráficos circulares 

pie(x=table(iris$Species))

pie(c(a=3,b=5,c=9,d=20, e=45, f=100))


# *barplot* hace gráficos de barras
barplot(height=table(iris$Species))



### B. FUNCIONES GRÁFICAS DE BAJO NIVEL ########################################

# Aquí vamos a utilizar las funciones *points*, *lines* y *legend*.

# *type="n"* frecuentemente se utiliza para crear un grafico vacío

plot(iris$Petal.Length ~ iris$Petal.Width, type="n")

plot(iris$Petal.Length ~ iris$Petal.Width, xlab="Petal Width", 
    ylab="Petal Length", cex.lab=1.5, cex.axis=1.5, bty="l", las=1, type="n")

# *points* añade puntos a un grafico creado por *plot*    

points(iris$Petal.Length[iris$Species=="setosa"] ~ 
    iris$Petal.Width[iris$Species=="setosa"])
    
    
points(iris$Petal.Length[iris$Species=="setosa"] ~ 
    iris$Petal.Width[iris$Species=="setosa"], pch=19, cex=1.5, col="lightblue")

points(iris$Petal.Length[iris$Species=="versicolor"] ~ 
    iris$Petal.Width[iris$Species=="versicolor"], pch=19, cex=1.5, 
    col="darkorange")
 
points(iris$Petal.Length[iris$Species=="virginica"] ~ 
    iris$Petal.Width[iris$Species=="virginica"], pch=19, cex=1.5, 
    col="grey50")


# *lines* añade líneas a un grafico    

lines(x=c(0, 2.5), y=rep(mean(iris$Petal.Length[iris$Species=="setosa"]), 2), 
    col="royalblue4", lwd=3)      

lines(x=c(0, 2.5), y=rep(mean(iris$Petal.Length[iris$Species=="versicolor"]), 2), 
    col="orange", lwd=3)      
    
lines(x=c(0, 2.5), y=rep(mean(iris$Petal.Length[iris$Species=="virginica"]), 2), 
    col="black", lwd=3)      


# *legend* añade una leyenda                

legend(x="topleft", legend=c(expression(italic("Iris setosa")), 
    expression(italic("Iris versicolor")), expression(italic("Iris virginica"))), 
    pch=19, col=c("lightblue", "darkorange", "grey50"), cex=1.3)
    
legend(x=1.3, y=2.3, legend=c(expression(italic("Iris setosa")), 
    expression(italic("Iris versicolor")), expression(italic("Iris virginica"))), 
    pch=19, col=c("lightblue", "darkorange", "grey50"), cex=1.3)



### C. PARÁMETROS GRÁFICOS MODIFICADOS POR LA FUNCIÓN *par* #################### 

# Para tomar mayor control sobre gráficos, es necesario conocer la función *par*
# y sus argumentos asociados. 

# Muchas características de los gráficos pueden especificarse usando la *par* o
# en las funciones gráficas como *plot* (e.g. color). Otras pueden especificarse 
# solo utilizando *par* (e.g. tamaño del margen). La ayuda de la función *par* 
# tiene mucha información útil:

help(par)

# Primera versión:

hist(iris$Sepal.Length, breaks=seq(0, 8, 0.5), col="gray70", border="gray40", 
    xlab="", ylab="", main="", axes=FALSE, ylim=c(0,40))

hist(iris$Petal.Length, breaks=seq(0, 8, 0.5), density=30, add=TRUE)

axis(side=1, at=seq(0, 8, 1), cex.axis=2, lwd=2, las=1)
axis(side=2, at=seq(0, 40, 5), cex.axis=1.5, cex.axis=2, lwd=2, las=1)

mtext(text="Length (cm)", side=1, line=3, cex=2)
mtext(text="Specimens", side=2, line=3.5, cex=2)

legend(x="topright", legend=c("Sepals", "Petals"), fill=c("gray70", "black"), 
    density=c(NA, 30), pt.cex=2, border=c("gray40", "black"), cex=2)
    
    
# En esta primera versión hay un obvio problema con el titulo en el eje de
# las y. Para corregirlo podemos utilizar el argumento *mar* en la función *par*.

# Segunda versión:

par(mar = c(5, 5, 4, 2), family="mono") # Esta es la única línea que es diferente

hist(iris$Sepal.Length, breaks=seq(0, 8, 0.5), col="gray70", border="gray40", 
    xlab="", ylab="", main="", axes=FALSE, ylim=c(0,40))

hist(iris$Petal.Length, breaks=seq(0, 8, 0.5), density=30, add=TRUE)

axis(side=1, at=seq(0, 8, 1), cex.axis=2, lwd=2, las=1)
axis(side=2, at=seq(0, 40, 5), cex.axis=1.5, cex.axis=2, lwd=2, las=1)

mtext(text="Length (cm)", side=1, line=3, cex=2)
mtext(text="Specimens", side=2, line=3.5, cex=2)

legend(x="topright", legend=c("Sepals", "Petals"), fill=c("gray70", "black"), 
    density=c(NA, 30), pt.cex=2, border=c("gray40", "black"), cex=2)



### D. Partir una ventana gráficos ###################

## 1. Crear una ventana con múltiples paneles con *par* ##

# El argumento *mfrow* necesita 2 números: el numero de filas y columnas en las 
# que la ventana se va a dividir:

par(mfrow=c(1,2))
plot(iris$Petal.Length ~ iris$Petal.Width, pch=19)
plot(iris$Sepal.Length, iris$Sepal.Width, pch=19, col="red")

par(mfrow=c(2,1))
plot(iris$Petal.Length ~ iris$Petal.Width, pch=19)
plot(iris$Sepal.Length, iris$Sepal.Width, pch=19, col="red")


## 2. Crear una ventana con múltiples paneles con *layout* ##

# La funcion *layout* también puede dividir una ventana en paneles, pero los
# paneles no tienen que ser del mismo tamaño u organizarse en filas y columnas

# El principal argumento para la función *layout* es una matriz que define como
# se parte la ventana:

div <- matrix(1:3, nrow=3, ncol=1)
div

layout(mat=div)
layout.show(3)

plot(iris$Sepal.Length, iris$Sepal.Width, pch=19, cex.lab=1.5, cex.axis=1.5, 
    xlab="Sepal length (cm)", ylab="Sepal width (cm)")
plot(iris$Sepal.Length, iris$Petal.Length, pch=19, cex.lab=1.5, cex.axis=1.5, 
    xlab="Sepal length (cm)", ylab="Petal length (cm)")
plot(iris$Sepal.Length, iris$Petal.Width, pch=19, cex.lab=1.5, cex.axis=1.5, 
    xlab="Sepal length (cm)", ylab="Petal width (cm)")


plot(iris$Sepal.Length, iris$Petal.Width, pch=19)
    

div <- matrix(1:4, nrow=2, ncol=2)
div

layout(mat=div)
layout.show(4)

plot(iris$Sepal.Length, iris$Sepal.Width, pch=19, cex.lab=1.5, cex.axis=1.5, 
    xlab="Sepal length (cm)", ylab="Sepal width (cm)")
plot(iris$Sepal.Length, iris$Petal.Length, pch=19, cex.lab=1.5, cex.axis=1.5, 
    xlab="Sepal length (cm)", ylab="Petal length (cm)")
plot(iris$Sepal.Length, iris$Petal.Width, pch=19, cex.lab=1.5, cex.axis=1.5, 
    xlab="Sepal length (cm)", ylab="Petal width (cm)")
plot(iris$Sepal.Length, iris$Petal.Width, pch=19, type="n", axes=F, bty="n", 
    xlab="", ylab="")
mtext("Sepal length", line=-3, cex=1.5)
mtext("versus", line=-5, cex=1.5)
mtext("other variables", line=-7, cex=1.5)
mtext("in Anderson's Iris", line=-9, cex=1.5)


# Esta es una gráfica sencilla con dos paneles

div <- matrix(1:2, nrow=1, ncol=2)
layout(mat=div)
layout.show(2)

plot(iris$Sepal.Length, iris$Sepal.Width)
plot(iris$Sepal.Length, iris$Petal.Length)


# Que tal si queremos hacer que el un panel sea "contenido" por el otro

div <- matrix(c(1,1,2,1), nrow=2, ncol=2)
div

layout(mat=div)
layout.show(2)

plot(iris$Sepal.Length, iris$Sepal.Width)
plot(iris$Sepal.Length, iris$Petal.Length)


# Además, con los argumentos *widths* y *heights* podemos cambiar el tamaño de
# las celdas en las columnas o filas

layout(mat=div, widths=c(2, 1), heights=c(1, 2))
layout.show(2)

plot(iris$Sepal.Length, iris$Sepal.Width)
plot(iris$Sepal.Length, iris$Petal.Length)




### E. GUARDAR GRÁFICOS COMO ARCHIVOS ########################################## 

# Así como es posible enviar un gráfico a una ventana abierta, es posible 
# enviar un gráfico a un archivo abierto (ambos son tipos de "graphical devices").

# Hay varias funciones que abren varios tipos de  archivos: 
# *jpeg*, *png*, *tiff*, *bmp*, *pdf*, *postcript*.


# Ejemplo utilizando *pdf*

help(pdf)


getwd() # ver cual es el directorio de trabajo

# Utilizar *getwd* o las opciones en la barra de R para asignar el directorio
# de trabajo que se quiere utilizar


## Primera versión ##
# Paso 1. Abrir el archivo:

pdf(file="SepalLenght_vs_SepalWidth.pdf", width = 9, height = 7) 

# Paso 2. Crear la figura en el archivo

plot(iris$Petal.Length ~ iris$Petal.Width, cex=3, pch=21, col="black", bg="grey",
    main="Plot of Petal Length vs. Petals Width", xlab="Petal Width", 
    ylab="Petal Length", cex.lab=1.5, cex.axis=1.5, bty="l", las=1)

# Paso 3. Cerrar el archivo

dev.off() 



## Segunda versión ##
# En esta versión hemos hecho la figura en formato png de tamaño grande y de buena calidad

png(filename="SepalLenght_vs_SepalWidth.png", width=480*13, height=480*10, 
    pointsize=12*1.5, res=600) 

plot(iris$Petal.Length ~ iris$Petal.Width, cex=3, pch=21, col="black", bg="grey",
    main="Plot of Petal Width vs. Petals Length", xlab="Petal Width", 
    ylab="Petal Length", cex.lab=1.5, cex.axis=1.5, bty="l", las=1)

dev.off() 







