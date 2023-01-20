################################################################################
### R BASICS WORKSHOP                                                					          ###
### PRESENTACIÓN 1.1: Introducción                           			         ###
###                                                               						                      ###
### Unida de Servicios Bioinformáticos    						                      ###
### Instituto Nacional de Medicina Genómica                                               			          ###
### Website: github.com/hachepunto/R_Basics_workshop			                                   ### 
################################################################################

## OBJECTIVE:
## El propósito de este ejercicio es familiarizarte con R y con la forma de 
## interactuar con la linea de comandos 


## PARTE 1 ##
# Aquí te introduciré a algunos conceptos importantes los cuales veremos con más 
# detalle durante el resto de las presentaciones.


# Para buscar en los manuales en linea, las referencias y otros materiales puedes usar
help.start()


# el símbolo '<-' se usa para indicar asignación. También se usa para guardar información
# en un objeto:
x <- 50

# En este primer comando asignaste el valor 50 al objeto llamado 'x'. 
# Los objetos en R se usan para guardar información. Para encontrar que está almacenado
# en un objeto solo es necesario escribir su nombre:
x

# R no corre lineas que comiencen con '#'. Esto se usa para crear comentarios. 

# R ya tiene integrados algunos valores de algunas constantes fundamentales.
# Por ejemplo para encontrar el valor de Pi, solo escribe: 
pi

# Puedes copiar el valor de Pi en otro objeto. Por ejemplo:
y <- pi
y
pi

# En R, las acciones, la manipulación de datos, las gráficas y los análisis se llevan
# a cabo usando funciones, las cuales son elementos de R que hacen acciones en específico.
# Por ejemplo, la función 'rnorm' genera valores a azar con distribución normal:
rnorm(50)

# Las funciones actúan en o son modificadas por argumentos. Los argumentos definen como
# trabajará una función. En este ejemplo, la función 'rnorm' es modificada por un 
# argumento que tiene el valor de 50. Como resultado, obtienes 50 valores al azar de una
# distribución normal. Puedes pedir el número de valores que quieras:
rnorm(50)
rnorm(5)
rnorm(1)

# Puedes almacenar el resultado de una función en un objeto para usarlo después con
# otro propósito:
x <- rnorm(50)

# Puedes hacer cosas con los valores almacenados en 'x'. Por ejemplo, puedes usar la
# función 'mean' para calcular la media de los valores dentro de 'x':
mean(x)

# Puedes calcular otros estadísticos, como la desviación estándar, o simplemente crear
# un resumen de los valores en x:
sd(x)
summary(x)

# Puedes cambiar el orden de los valores:
sort(x)
sort(x, decreasing=TRUE)

# Por ejemplo, nota que la función 'sort' toma dos argumentos, uno son los valores
# en 'x', el otro es el valor 'TRUE'. ya aprenderemos más acerca de los argumentos.

# También puedes hacer un histograma de estos valores:
hist(x)

# R también tiene 'operadores' que efectúan una multitud de acciones. Los más comunes 
# son los operadores aritméticos de suma '+', resta '-', multiplicación '*', y 
# división '/'. Por ejemplo, podemos multiplicar los valores en 'x' por una constante:
x*2

# Tambien podemos escribir una sola linea de código que haga múltiples acciones y 
# guarde la salida. Por ejemplo:
y <- rnorm(50)*2

# Esto crea 50 valores al azar de una distribución normal, Luego multiplica cada valor
# por 2 y finalmente guarda el resultado en un objeto llamado 'y'.

# Podemos crear también secuencias de acciones más complicadas, por ejemplo:
y <- 0.5 + 1.5*x + rnorm(50)

# Esto 1) crea un conjunto de 50 valores al azar de una distribución normal, 2) 
# multiplica los valores en 'x' por 1.5, 3) suma elemento por elemento los resultados
# por (1) y (2), 4) suma 0.5 a cada valor en el resultado de (3), y 5) guarda los 
# resultados de este cómputo dentro de 'y'. Para ver el valor dentro de 'y' solo escribe:
y

# Ahora puedes usar los valores en los objetos 'x' y 'y' para muchas cosas. Por ejemplo,
# para hacer un scatterplot puedes usar la función 'plot':
plot(x, y)

# Esto tendría que abrir automáticamente una ventana de gráficos. Para hallar la 
# correlación entre 'x' y 'y':
cor(x, y)


# Para producir un boxplot y hacer una prueba de t:
boxplot(x,y)

# Para hacer una prueba de t:
t.test(x, y)

# Para hacer una prueba de t de una cola:
t.test(x, y, alternative="greater")

# Nota la diferencia entre los valores de p.


# Para ver que hay en tu espacio de trabajo hasta ahora, simplemente escribe:
ls()

# Nota que los objetos que has creado están enlistados ('x' y 'y')


## PARTE 2 ##
# En esta segunda parte seguirás jugando con varios elementos de R.
# Solamente ejecuta el código y mira los resultados. Sería mejor si trataras de escribir 
# el código en vez de solo copiar y pegar:


# Para hacer varias gráficas del sin(theta):
theta <- seq(0, 2*pi, length=100)
plot(theta, sin(theta))
par(new=TRUE)
plot(theta, sin(theta), type="h")
plot(theta, sin(theta), type="l")
plot(theta, sin(theta), type="s")
theta <- seq(0, 2*pi, length=10)
plot(theta, sin(theta), type="l")

# Para ver que significa un comando, escribe:
help(plot)


# Para hacer simple aritmética y repetir secuencias escribe:
c(1:25)
seq(1, 25)
seq(25, 1, -1)
seq(1, 25, 2)
seq(1, 25, length=6)
seq(0, 2, 0.1)
rep(0, 25)
rep(1, 25)


# Genera un vector de enteros del 1 al 25:
n <- c(1:25)


# Haz una columna de vectores igual a la raíz cuadrada de n:
w <- sqrt(n)


# Simula alguna respuesta de variables, y despliégalas en una tabla:
r <- n + rnorm(n) * w
data.frame(n, r)

# Ejecuta una regresión lineal, despliega los resultados, crea un scatterplot, y dibuja 
# la regresión lineal en rojo en la gráfica:
regress.rn <- lm(r ~ n)
summary(regress.rn)
plot(n, r)
abline(regress.rn, col="red")

# Nota que el orden de r y n de la linea de regresión es opuesta al del orden en 
# la gráfica.


# Grafica los residuos y ponle leyendas a los ejes:
plot(fitted(regress.rn), resid(regress.rn), xlab="ValoresAjustados",  
	ylab="Residuos", main="Residuos vs Ajustados")


# Simula 100 lanzamientos de una moneda y ve los resultados:
x <- rbinom(100,1,0.5)
x

# Luego, guarda el total acumulado de número de caras, grafica los resultados 
# con pasos (type = "s"):
c <- cumsum(x)
plot(c, type="s")


# Tira un dado 1000 veces y mira un resumen:
fair <- sample(c(1:6), 1000, replace=TRUE)
summary(fair)


# Tira un dado sesgado 1000 veces y ver un resumen:
biased <- sample(c(1:6), 1000, replace=TRUE, prob=c(1/12,1/12,1/12,1/4,1/4,1/4))
summary(biased)


# El siguiente conjunto de datos surgen del famoso experimento de Michelson-Morley. 
# Hay cinco experimentos (columna 'Expt') y cada uno tiene 20 corridas (columna 'Run') 
# y 'Speed' es la velocidad de la luz grabada menos 290,000 km/sec. 
# Para ver el conjunto de datos, escribe:
morley


# Los datos de las primeras dos columnas son leyendas. Haz el número de experimento un 
# factor:
morley$Expt <- factor(morley$Expt)

# Ahora, haz un boxplot con las leyendas de la velocidad en la columna 3:
boxplot(morley[ ,3] ~ morley$Expt, main="Datos de la velocidad de la luz", 
  xlab="Experimento", ylab="Velocidad")

# Ejecuta un análisis de varianza para ver si las velocidades medidas son 
# significativamente distintas entre experimentos.
anova.mm <- aov(Speed ~ Expt, data=morley)
summary(anova.mm)

# Dibuja una cúbica:
x <- seq(-2, 2, 0.01)
plot(x, x^3-3*x, type="l")

# Dibuja una curva de campana:
curve(dnorm(x), -3, 3)

# Checa la función de masa de probabilidad de una distribución binomial:
x <- c(0:100)
prob <- dbinom(x, 100, 0.5)
plot(x, prob, type="h")

# Para trazar una curva parametrizada, comenzar con una secuencia y dar los valores 
# de 'x' y 'y':
angle <- seq(-pi, pi, 0.01)
x <- sin(3*angle)
y <- cos(4*angle)
plot(x, y, type="l")


# Ahora vamos a trazar curvas de nivel y una superficie. En primer lugar, le damos una 
# secuencia de valores. Esta vez especificamos el número de términos:
x <- seq(-pi, pi, len=50)
y <- x

# Entonces, definimos una función de estos valores 'x' y 'y' y dibujamos un mapa 
# de contornos.
f <- outer(x, y, function(x, y) (cos(3*x) + cos(y)) / (1 + x^2 + y^2))
contour(x,y,f)

# Para dibujar un gráfico de superficie:
persp(x,y,f,col="orange")

# Para cambiar el ángulo de visión:
persp(x, y, f, col="orange", theta=-30, phi=45)


