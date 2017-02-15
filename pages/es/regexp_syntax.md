---
layout: page
lang: es
ref: syntax
title: Syntax von Regulären Ausdrücken
permalink: /es/regexp_syntax.html
---

Sintaxis de las Expresiones Regulares
=====================================

Introducciуn

 

Las Expresiones Regulares son un mйtodo ampliamente empleado para
especificar "plantillas" de texto a buscar. Los metacaracteres
especiales permiten especificar, por ejemplo, que una cadena en
particular que se estб buscado aparezca al inicio o al fin de una lнnea,
o que contenga n repeticiones de cierto caracter.

 

Las expresiones regulares lucen incomprensibles para los novatos, pero
en realidad son muy simples (bueno, usualmente simples ;) ), y son una
herramienta prбctica y poderosa.

 

Les recomiendo especialmente hacer pruebas con e.r. usando
[TestRExp.dpr](#tregexpr_testrexp.html) - ayuda a comprender muchos
conceptos. Ademбs hay muchos ejemplos predefinidos con comentarios,
incluidos en este proyecto.

 

Iniciemos el recorrido de aprendizaje!

 

 

Bъsquedas simples

 

Cualquier caracter se encuentra a sн mismo, a menos que se trate de un
metacaracter con significado especial, descriptos abajo.

 

Una serie de caracteres encuentra esa misma serie en la cadena objetivo,
por lo tanto la plantilla "bluh" encontrarб "bluh'' en la cadena
objetico. Simple, no?

 

Se puede conseguir que los caracteres que normalmente funcionan como
metacaracteres o secuencias de escape sean interpretadas literalmente
precediйndolas con el sнmbolo "\\" (backslash). Por ejemplo, el
metacaracter "^" significa inicio de la cadena, pero "\\^" encuentra el
sнmbolo "^", "\\\\" encuentra "\\", y asн para todos los casos
especiales.

 

Ejemplos:

  foobar         encuentra la cadena 'foobar'

  \\^FooBarPtr     encuentra '^FooBarPtr'

 

 

Secuencias de escape

 

Algunos casos especiales pueden ser especificados usando sintaxis de
secuencias de escape como las empleadas en C y Perl: "\\n'' significa
nueva lнnea, "\\t'' equivale a tab, etc. Mбs generalmente, \\xnn, donde
nn es un nъmero hexadecimal, encuentra el caracter cuyo valor  ASCII es
nn. Para usar cуdigos dobles de Unicode, se puede especificar
'\\x{nnnn}', donde 'nnnn' - es uno o mбs valores hexadecimales.

 

  \\xnn     caracter con cуdigo hexadecimal nn

  \\x{nn} caracter con cуdigo hexadecimal nnnn (un byte para texto comъn
y dos para [Unicode](#tregexpr_interface.html))

  \\t       tab (HT/TAB), lo mismo que \\x09

  \\n       lнnea nueva (NL), lo mismo que \\x0a

  \\r       retorno de carro (CR), lo mismo que \\x0d

  \\f       salto de hoja (FF), lo mismo que \\x0c

  \\a       alarma (bell) (BEL), lo mismo que \\x07

  \\e       escape (ESC), lo mismo que \\x1b

 

Ejemplos:

  foo\\x20bar   encuentra 'foo bar' (notar el espacio en el medio)

  \\tfoobar     encuentra 'foobarar' precedido por tab

 

 

Clases de caracteres

 

Se pueden especificar clases de caracteres encerrando una lista de
caracteres entre corchetes \[\], la que que encontrarб uno cualquiera de
los caracteres de la lista.

 

Si el primer sнmbolo despuйs deI "\['' es "^'', la clase encuentra
cualquier caracter que no estб en la lista.

 

Ejemplos:

  foob\[aeiou\]r   encuentra las cadenas 'foobar', 'foober' etc. pero no
'foobbr', 'foobcr' etc.

  foob\[^aeiou\]r encuentra las cadenas 'foobbr', 'foobcr' etc. pero no
'foobar', 'foober' etc.

 

Dentro de una lista, el sнbolo "-'' es utilizado para especificar un
rango, entonces a-z representa todos los caracteres entre "a'' y "z''
inclusive.

 

Para que "-'' forme parte de la clase hay que ubicarlo al inicio o final
de la lista, o usar la secuencia de escape "\\-". Para usar '\]' en la
lista hay que ubicarlo al inicio de la lista o usar la secuencia "\\\]".

 

Ejemplos:

  \[-az\]     encuentra 'a', 'z' y '-'

  \[az-\]     encuentra 'a', 'z' y '-'

  \[a\\-z\]     encuentra 'a', 'z' y '-'

  \[a-z\]     encuentra todas las minъsculas de 'a' hasta 'z'

  \[\\n-\\x0D\] encuentra cualquiera de \#10,\#11,\#12,\#13.

  \[\\d-t\]     encuentra cualquier dнgito, '-' or 't'.

  \[\]-a\]     encuentra cualquier caracter de '\]' hasta 'a'.

 

 

Metacaracteres

 

Los metacaracteres son caracteres especiales que son la esencia de las
Expresiones Regulares. Hay diferentes tipos:

 

Metacaracteres - separadores de lнneas

 

  ^     inicio de lнnea

  $     fin de lнnea

  \\A     inicio de texto

  \\Z     fin de texto

  .     cualquier caracter en la lнnea

 

Ejemplos:

  ^foobar     encuentra 'foobar' sуlo si estб al principio de una lнnea

  foobar$     encuentra 'foobar' sуlo si estб al final de una lнnea

  ^foobar$   encuentra 'foobar' sуlo si es la ъnica cadena en la lнnea

  foob.r     encuentra cadenas tipo 'foobar', 'foobbr', 'foob1r'

 

El metacaracter "^" por defecto sуlo garantiza encontrar coincidencias
al principio de la cadena/texto analizados, y "$" sуlo al final. Los
separadores de lнnea intermedios no son encontrados por "^'' o "$''.

Sin embargo, se puede tratar una cadena como multilнnea, de esta forma
"^'' encontrarб coincidencias despuйs de cualquier separador de lнnea
dentro de esta cadena, y "$'' darб resultados positivos antes de
cualquier separador. Esto se logra activando el modificador /m.

Las secuencias \\A y \\Z son como "^'' y "$'', excepto que no dan
resultados mъltiples aunque estй activado el modificador /m, mientras
que "^'' y "$'' encontrarбn coincidencias en todos los separadores de
lнnea internos.

 

El metacaracter ".'' por defecto encuentra cualquier caracter, pero si
se desactiva el modificador /s entonces '.' no encuentra separadores de
lнnea internos.

 

TRegExpr trabaja con los separadores de lнnea segъn las recomendaciones
de www.unicode.org ( http://www.unicode.org/unicode/reports/tr18/ ):

 

"^" al inicio de la cadena ingresada, y si el modificador /m estб
activado, tambiйn inmediatamente despuйs de toda ocurrencia de
\\x0D\\x0A, \\x0A o \\x0D (si se usa la versiуn
[Unicode](#tregexpr_interface.html) de TRegExpr, tambiйn \\x2028,
 \\x2029, \\x0B, \\x0C o \\x85). Notar que no hay una lнnea vacнa dentro
de la secuencia \\x0D\\x0A.

 

"$" al final de la cadena ingresada, y si el modificador /m estб
activado, tambiйn inmediatamente antes de toda ocurrencia de
 \\x0D\\x0A, \\x0A, o \\x0D (si se usa la versiуn Unicode de TRegExpr,
tambiйn \\x2028,  \\x2029, \\x0B, \\x0C o \\x85). Notar que no hay una
lнnea vacнa dentro de la secuencia \\x0D\\x0A.

 

"." encuentra cualquier caracter, pero si se desactiva el modificador /s
entonces "." no encuentra \\x0D\\x0A, \\x0A y \\x0D (si se usa la
versiуn Unicode de TRegExpr, tambiйn \\x2028,  \\x2029, \\x0B, \\x0C y
\\x85).

 

Notar que "^.\*$" (plantilla de lнnea vacнa) no encuentra la cadena
vacнa dentro de la secuencia \\x0D\\x0A, pero sн dentro de la secuencia
\\x0A\\x0D.

 

El procesamiento multilнnea puede ser fбcilmenet afinado para sus
propуsitos con la ayuda de las propiedades LineSeparators y
LinePairedSeparator de TRegExpr. Se pueden usar sуlo separadores tipo
Unix ( \\n ) o sуlo tipo DOS/Windows ( \\r\\n) o todos juntos (como se
describe arriba y usado por defecto), o incluso definir sus propios
deparadores de lнnea !

 

Metacaracteres - clases predefinidas

 

  \\w     un caracter alfanumйrico (incluye "\_")

  \\W     un caracter no alfanumйrico

  \\d     un caracter numйrico

  \\D     un caracter no numйrico

  \\s     cualquier espacio (lo mismo que \[ \\t\\n\\r\\f\])

  \\S     un no espacio

 

Se pueden usar las clases \\w, \\d y \\s dentro de las clases de
caracteres personales.

 

Ejemplos:

  foob\\dr     encuentra cadenas como 'foob1r', ''foob6r' pero no
'foobar', 'foobbr'

  foob\[\\w\\s\]r encuentra cadenas como 'foobar', 'foob r', 'foobbr'
pero no 'foob1r', 'foob=r'

 

TRegExpr usa las propiedades SpaceChars y WordChars para definir las
clases de caracteres \\w, \\W, \\s, \\S, por lo tanto se pueden
redefinir fбcilmente.

 

NOTA PARA USUARIOS DE IDIOMA ESPAСOL:

 

La propiedad WordChars por defecto estб definida con el siguiente
conjunto de caracteres:

 

WordChars =
'0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ\_'

 

Para nuestro idioma lo correcto serнa:

WordChars =
'0123456789aбbcdeйfghiнjklmnсoуpqrstuъvwxyzAБBCDEЙFGHIJKLMNСOУPQRSTUЪVWXYZ\_'

 

 

Metacaracteres - lнmites de palabras

 

  \\b                                encuentra lнmite de palabra

  \\B                                encuentra distinto a lнmite de
palabra

 

Un lнmite de palabra (\\b) es un punto entre dos caracteres que estб
limitado por un \\w de un lado y un \\W en el otro (en cualquier orden),
contando los caracteres imaginarios del inicio y final de la cadena como
coincidencias con \\W.

 

 

 

Metacaracteres - iteradores

 

Cualquier item de una expresiуn regular puede ser seguido por otro tipo
de metacaracteres, los iteradores. Usando estos metacaracteres se puede
especificar el nъmero de ocurrencias del caracter previo, de un
metacaracter o de una subexpresion.

 

  \*     cero o mбs ("voraz"), similar a {0,}

  +   una o mбs ("voraz"), similar a {1,}

  ?   cero o una ("voraz"), similar a {0,1}

  {n}   exactamente n veces ("voraz")

  {n,}   por lo menos n veces ("voraz")

  {n,m} por lo menos n pero no mбs de m veces ("voraz")

  \*?     cero o mбs ("no voraz"), similar a {0,}?

  +?     una o mбs ("no voraz"), similar a {1,}?

  ??     cero o una ("no voraz"), similar a {0,1}?

  {n}?   exactamente n veces ("no voraz")

  {n,}? por lo menos n veces ("no voraz")

  {n,m}? por lo menos n pero no mбs de m veces ("no voraz")

 

Entonces, los dнgitos entre llaves de la forma {n,m}, especifican el
mнnimo nъmero de ocurrencias en n y el mбximo en m. La forma {n} es
equivalente a {n,n} y coincide exactamente n veces. La forma {n,}
encuentra ocurrencias de n o mбs veces. No hay lнmites para los nъmero n
o m, pero si son muy grandes se consume mбs memoria y la ejecuciуn de la
e.r. se hace mбs lenta.

 

Si una llave aparece en otro contexto se la trata como un caracter
regular.

 

Ejemplos:

  foob.\*r     encuentra cadenas como 'foobar', 'foobalkjdflkj9r' y
'foobr'

  foob.+r     encuentra cadenas como 'foobar', 'foobalkjdflkj9r' pero no
'foobr'

  foob.?r     encuentra cadenas como 'foobar', 'foobbr' y 'foobr' pero
no 'foobalkj9r'

  fooba{2}r   encuentra la cadena 'foobaar'

  fooba{2,}r encuentra cadenas como 'foobaar', 'foobaaar', 'foobaaaar'
etc.

  fooba{2,3}r encuentra cadenas como 'foobaar', o 'foobaaar' pero no
'foobaaaar'

 

Una mнnima explicacion acerca de la "voracidad". "Voraz" toma la mayor
cantidad posible, "no voraz" toma la mнnima cantidad posible. Por
ejemplo, 'b+' y 'b\*' aplicados a la cadena 'abbbbc' devuelven 'bbbb',
'b+?' devuelve 'b', 'b\*?' devuelve unacadena vacнa, 'b{2,3}?' devuelve
'bb', 'b{2,3}' devuelve 'bbb'.

 

Se pueden activar todos los iteradores para que funcione en modo "no
voraz" (ver el modificador /g).

 

 

Metacaracteres - alternativas

 

Se puede especificar una serie de alternativas para una plantilla usando
"|'' para separarlas, entonces fee|fie|foe encontrarб cualquier "fee'',
"fie'', o "foe'' en la cadena objetivo (lo mismo serнa f(e|i|o)e). La
primera alternativa incluye todo desde el ultimo delimitador ( "('',
"\['', o el inicio de la plantilla) hasta el primer "|'', y la ъltima
alternativa contiene todo desde el ъltimo "|''hasta el siguiente
delimitador de plantilla. Por esta razуn es una prбctica comъn incluir
las alternativas entre parйntesis, para minimizar la confusiуn de dуnde
se inician y dуnde terminan.

Las alternativas son evaluadas de izquierda a derecha, por lo tanto la
primera alternativa que coincide plenamente con la expresiуn analizada
es la que se selecciona. Esto significa que las alternativas no son
necesariamente voraces. Por ejemplo: si se buscam foo|foot en
"barefoot'', sуlo la parte "foo'' da resultado positivo, porque es la
primera alternativa probada, y porque tiene йxito en la bъsqueda de la
cadena analizada. (Esto puede no parecer importante, pero lo es cuando
se estб capturando el texto buscado usando parйntesis.)

Tambiйn recordar que "|'' es interpretado literalmente dentro de los
corchetes, entonces si se escribe \[fee|fie|foe\] lo ъnico que se
encuentra es \[feio|\].

 

Ejemplo:

  foo(bar|foo) encuentra las cadenas 'foobar' o 'foofoo'.

 

 

Metacaracteres - subexpresiones

 

La construcciуn ( ... ) tambiйn puede ser empleada para definir
subexpresiones de e.r. (despuйs del anбlisis se obtienen las posiciones
de las subexpresiones, su longitud y el valor actual en las propiedades
MatchPos, MatchLen y Match de TRegExpr; y se pueden substituir en
cadenas de plantillas con TRegExpr.Substitute).

 

Las subexpresiones son numeradas de izquierda a derecha en base al orden
de sus parйntesis de apertura. La primera subexpresiуn es la '1' (la
e.r. completa tiene el nъmero '0' - Se puede substituir en
TRegExpr.Substitute como '$0' o '$&').

 

Ejemplos:

  (foobar){10} encuentra cadenas que contienen 8, 9 o 10 instancias de
'foobar'

  foob(\[0-9\]|a+)r encuentra 'foob0r', 'foob1r' , 'foobar', 'foobaar',
'foobaar' etc.

 

 

Metacaracteres - memorias (backreferences)

 

Los metacaracteres \\1 a \\9 son interpretados como memorias.
\\&lt;n&gt; encuentra la subexpresiуn previamente encontrada
\#&lt;n&gt;.

 

Ejemplos:

  (.)\\1+         encuentra 'aaaa' y 'cc'.

  (.+)\\1+       tambiйn encuentra 'abab' y '123123'

  (\['"\]?)(\\d+)\\1 encuentra '"13" (entre comillas dobles), o '4'
(entre comillas simples) o 77 (sin comillas) etc

 

 

Modificadores

 

Los modificadores son para cambiar el comportamiento de TRegExpr.

 

Hay varias formas de configurar los modificadores.

Cualquiera de estos modificadores pueden incluirse dentro de las
expresiones regulares usando la estructura (?...).

Tambiйn se pueden asignar las propiedades adecuadas de TRegExpr
(ModifierX por ejemplo, para cambiar /x, o ModifierStr para cambiar
todos los modificadores simultбneamente). Los valores por defecto para
nuevas instancias de TRegExpr estбn definidos en variables globales, por
ejemplo la variable global RegExprModifierX define el valor de la
propiedad ModifierX en las nuevas instacias del objeto TRegExpr.

 

i

Bъsquedas insensibles a mayъsculas, ver tambiйn InvertCase.

m

Tratamiento de cadenas como mъltiples lнneas. Esto es, cambia a "^'' y
"$'' de encontrar solo en el inicio y fin de la cadena al inicio y fin
de cada lнnea dentro de la cadena, ver tambiйn Separadores de lнneas.

s

Tratamiento de cadenas cуmo lнnea simple. Esto es, cambia ".'' para
encontrar cualquier caracter en cualquier lado, incluso separadores de
lнnea (ver Separadores de lнnea), que  normalmente no son encontradod.

g

Modificador no standard. Al desactivarlo se cambian todos los operadores
siguientes en modo no voraz (por defecto este modificador esta
activado). Entonces, si el modificador /g estб Off entonces '+' funciona
como '+?', '\*' como '\*?', etc.

x

Aumenta la legibilidad de las plantillas al permitir espacios en blanco
y comentarios (ver la explicaciуn mбs abajo).

r

Modificador no standard para incluir letras rusas en el rango de
caracteres.

Perdуn a los usuarios extranjeros, pero estб activado por defecto. Para
desactivarlo por defecto cambiar a False la variable global
RegExprModifierR.

 

 

El modificador /x necesita un poco mбs de explicaciуn. Le dice a
TRegExpr que ignore los espacios blancos que no estбn precedidos por
"\\" o no incluнdos en una clase de caracteres. Se puede usar para
separar las expresiones regulares en partes mбs legibles. El caracter \#
es tratado como metacaracter para comentarios, por ejemplo:

 

(

(abc) \#comentario 1

  |   \#Se pueden usar espacios para formatear e.r.

(efg) \#comentario 2

)

 

Esto significa que si se desea usar realmente un espacio o \# en una
plantilla (fuera de clases de caracteres, donde no son afectadas por
/x), hay que usar "\\" o codificarlos en su valor ASCII en octal o
hexadecimal.

 

Extensiones de Perl

 

(?imsxr-imsxr)

Se pueden usar dentro de las e.r. para cambiar modificaciones
instantбneamente. Si esta construcciуn estб incluнda dentro de una
subexpresiуn, entonces sуlo afecta a la subexpresiуn.

 

Ejemplos:

  (?i)Saint-Petersburg       encuentra 'Saint-petersburg' y
'Saint-Petersburg'

  (?i)Saint-(?-i)Petersburg encuentra 'Saint-Petersburg' pero no
'Saint-petersburg'

  (?i)(Saint-)?Petersburg   encuentra 'Saint-petersburg' y
'saint-petersburg'

  ((?i)Saint-)?Petersburg   encuentra 'saint-Petersburg', pero no
'saint-petersburg'

 

 

(?\#text)

Comentario, el texto es ignorado. Notar que TRegExpr cierra el
comentario apenas encuentra un ")", por lo tanto no hay forma de poner
un ")" literal en el comentario.

 
