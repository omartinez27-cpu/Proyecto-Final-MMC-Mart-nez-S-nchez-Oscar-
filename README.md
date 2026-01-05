# Proyecto-Final-MMC-Mart-nez-S-nchez-Oscar-
Análisis de Elementos Finitos para placas con la teoría de Reissner-Midlin
-----READ ME-----  

Análisis numérico por el método de Elementos Finitos de placas rectangulares 
y circulares basado en la teoría de Reissner-Midlin.

Este programa se ejecuta íntegramente en MATLAB por lo tanto no requiere de 
librerías externas.
El programa se compone por 10 archivos en formato .m, los cuales se 
enlistan a continuación:

1.	runner
2.	malladounifome
3.	malladocircular
4.	RigidezElemento
5.	EnsamblajeKglobalPlaca
6.	CrearVectordeFuerzas
7.	AgregarCargaUniforme
8.	AgregarCargaPuntual
9.	CondicionesdeContorno
10.	ProcesarResultadosPlaca

Instrucciones:

Todo se ejecuta desde el archivo principal llamado "runner"
En este archivo se ingresan los datos de entrada en la secuencia que
se indica a continuación:

El tipo de placa (circular o rectangular) se define en las líneas 8 y 9
solo se puede seleccionar una de las dos opciones y la otra deberá ser
deshabilitada usando un símbolo de porcentaje al inicio del renglón.

Ej:
%Tipo= 'Circular';  
Tipo= 'Rectangular'; 
En este caso estamos seleccionando una placa rectangular para analizar. 

Posteriormente en la sección siguiente se introducirán datos para
las dimensiones de la placa (lados o radio) y su espesor, seguido de 
los datos para el refinamiento del mallado definidos con las variables
p y m para el numero de divisiones en dos sentidos, vertical y horizontal
para placas rectangulares, angular y radial para placas circulares, para el 
caso de las divisiones angulares se recomienda al menos 30, usar menos
divisiones genera un polígono regular que no se asemeja tanto a un circulo.

Respecto a los datos del material se deberá ingresar el Modulo de elasticidad
y el Módulo de Poisson del material en cuestión, es necesario verificar la
compatibilidad de las unidades ingresadas para evitar errores en el análisis.

Una vez ingresados todos los datos de preproceso es necesario realizar 
algunos ajustes manuales para activar/desactivar las funciones que se usan
únicamente en alguno de los dos casos. Recordando que esto se hace escribiendo 
un signo de porcentaje (%) al inicio de la linea que queremos deshabilitar. 
De esta manera podemos evitar errores en la ejecución del
codigo.


En el apartado de proceso se deberá seleccionar la función con la geometría 
que corresponda al caso en cuestión para generar el ensamblaje  global de 
la placa de manera correcta, No seleccionar la función correcta levara a un 
error en el mallado de los elementos en la placa, 

Para agregar las cargas el usuario deberá seleccionar uno de los dos 
casos disponibles, Carga puntual y carga distribuida para el caso de
carga puntual se requiere el nodo central de la placa y para obtenerlo
es necesario haber realizado una corrida "falsa" con la finalidad de
generar el mallado y ubicar el nodo en el que asignaremos la carga, este 
nodo será el que se ubique en las coordenadas (L1/2, L2/2), también es 
posible buscarlo manera manual en la variable NL del workspace, una 
vez identificado el valor se asignara a la variable coord_objetivo en 
la linea 29.

Finalmente deberemos en la sección de postproceso deberemos seleccionar 
el caso que corresponda a la placa analizada para comparar el desplazamiento 
máximo obtenido por elementos finitos contra una solución analítica o 
aproximada mediante series para la placa con la geometría y condiciones 
de frontera correspondientes.

Por ultimo correr el programa y observar las graficas obtenidas de 
desplazamiento y curvaturas para asegurarnos que estas muestren un 
comportamiento adecuado con la geometría y carga deseadas.

Dudas o comentarios: o.martinez27@alumnos.uaq.mx
