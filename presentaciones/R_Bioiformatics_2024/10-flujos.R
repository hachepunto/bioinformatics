################################################################################
### Introducci�n a R                                                         ###
###    ______       _                                                        ###
###   / __/ /_ __  (_)__  ___                                                ###
###  / _// / // / / / _ \(_-<                                                ###
### /_/ /_/\_,_/_/ /\___/___/                                                ###
###           |___/                                                          ###
### Instituto Nacional de Medicina Gen�mica                                  ###
### Enero 2024                                                               ###
### Hugo Tovar <hatovar@inmegen.gob.mx>                                      ### 
################################################################################

### INTRODUCCION ###############################################################

# En R hay una serie de elementos que te permiten controlar el flujo del c�digo.
# Hay 4 tipos principales maneras de controlar flujo:

# 1. Bucles (loops) *for*
# 2. Bucles (loops) *while*
# 3. Condicionales 
# 4. Rupturas (breaks)

# Para esta presentaci�n nos vamos a enfocar en *for*, *while* e *if*

## IMPORTANTE: para ayuda con control de flujo:

help(Control)


################################################################################
### 1. BUCLES *for* ############################################################
################################################################################

# Un bucle permite repetir un pedazo de c�digo m�ltiples veces sin tener que 
# repetirlo.

# *for* es la manera mas com�n de construir bucles. Este tipo de bucle repite 
# un pedazo de c�digo un numero pre-determinado de veces.


# La estructura general de un bucle *for* es la siguiente:
#
# for(i in vector)
# {
#   code
# }


# Esto quiere decir aproximadamente:
#
# para cada valor que i toma del vector repetir
# {
#   este c�digo
# }


#####################
## Ejemplo f�cil 1 ##
#####################

v <- 1:10

for(i in v)
{
    print(i)
}

# Esto se traduce como:
#
# Crear una secuencia del 1 al 10 y guardarla como un objeto llamado *v*
# 
# Para cada valor que la variable *i* toma del vector *v* hacer lo siguiente:
# imprimir el valor de i
#


#####################
## Ejemplo f�cil 2 ##
#####################

v <- letters

v

for(i in v)
{
    print(i)
}


#####################
## Ejemplo f�cil 3 ##
#####################

v <- letters

length(v)

result <- 0

for(i in v)
{
	print(i)
	result <- result + 1
}

result


#####################
## Ejemplo f�cil 4 ##
#####################

v <- c(1,3,5,2,4)

result <- 0

for(i in 1:length(v))
{
	print( c(i, v[i]) )

	result <- result + v[i]
}

result


#####################
## Ejemplo f�cil 5 ##
#####################

col.v <- rainbow(100)
cex.v  <- seq(1, 10, length.out=100)

plot(0:1, 0:1, type="n")

for(i in 1:200)
{
	print(i)

	points(runif(1), runif(1), pch=16, col=sample(col.v, 1), 
	    cex=sample(cex.v, 1))

	Sys.sleep(0.1)
}

#####################
## Ejemplo f�cil 6 ##
#####################

# La secuencia de Fibonacci es una secuencia famosa en matem�ticas. Los primeros 
# dos elementos son 1 y 1. Los elementos posteriores se definen como la suma de 
# los dos inmediatamente anteriores. Por ejemplo, el tercer elemento es 2 
# (1 + 1), el cuarto elemento es 3 (2 + 1), y as� sucesivamente. En este ejemplo, 
# vamos a calcular los primeros 'n' n�meros en la secuencia de Fibonacci.

# Esto crea una variable que determina la longitud de la secuencia de Fibonacci:

n <- 25

# A menudo es �til para crear un objeto vac�o que almacenar� los valores creados
# en cada iteraci�n de un bucle. En este caso, creamos un vector vac�o de
# longitud 'n':

fibonacci <- rep(NA, times=n)

# Comprobamos el contenido de 'fibonacci':

fibonacci

# Por definici�n, los primeros dos elementos de la secuencia son 1 y 1:

fibonacci[1] <- 1
fibonacci[2] <- 1

# Este bucle calcular� los elementos 3 a 'n' de la secuencia:

for(i in 3:n)
{
  # El elemento 'i' se calcula como la suma de los elementos'i-1' e 'i-2'
  fibonacci[i] <- fibonacci[i-1] + fibonacci[i-2]
}

# Ahora podemos ver el resultado del bucle - la secuencia de Fibonacci de 1 al 
# elemento "n":

fibonacci



################################################################################
### 2. BUCLES *while* ##########################################################
################################################################################

# *while* tambi�n es muy �til para construir bucles. Este tipo de bucle repite
# un pedazo de c�digo mientras una condici�n determinada es cierta.

# La estructura general de un bucle *while* es la siguiente:
#
# while(condici�n)
# {
#   c�digo
# }

# Esto quiere decir aproximadamente:
#
# mientras esta condici�n es verdadera repetir
# {
#   este c�digo
# }


#####################
## Ejemplo f�cil 1 ##
#####################

v <- 1:10

# Versi�n 1
i <- 0
while(i < max(v))
{
	i <- i+1
	print(i)
}


#####################
## Ejemplo f�cil 2 ##
#####################

i <- 0
while(i < max(v))
{
	print(i)
	i <- i+1
}



################################################################################
### 3. CONDICIONAL: *if* #######################################################
################################################################################

# El condicional *if* permite correr un pedazo de c�digo solamente si una 
# condic�n en particular es verdadera

#####################
## Ejemplo f�cil 1 ##
#####################

v <- 1:10

for(i in v)
{
	print(i)

	if(i == 5)
		print("Reached 5") # Con un solo comando, las llaves {} no son necesarias
}


#####################
## Ejemplo f�cil 2 ##
#####################

trait <- 0
max.time <- 100

plot(c(0,max.time), c(-20, 20), type="n", 	ylab="Trait Value", xlab="Time")

points(0, trait, pch=16, col="black")

for(i in 1:max.time)
{
	trait.shift <- rnorm(1, 0, 0.5)
	trait <- trait + trait.shift 

	if(trait.shift > 0) 
	    COL <- "gold"
	if(trait.shift < 0) 
	    COL <- "lightblue"
	
	points(i, trait, pch=16, col=COL)

	Sys.sleep(0.2)
}



################################################################################
### 4. RUPTURAS: *break* #######################################################
################################################################################

# La funci�n *break* causa que un bucle termine. Se usa frecuentemente en 
# conjunto con un condicional

#####################
## Ejemplo f�cil 1 ##
#####################

v <- 1:10

for(i in v)
{
	print(i)

	if(i == 5) # Con mas de un comando, las llaves {} son necesarias
	{ 
		print("Reached 5")
		break()
	}
}
