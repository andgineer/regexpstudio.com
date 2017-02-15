---
layout: page
lang: es
ref: faq
title: FAQ
permalink: /es/faq.html
---

FAQ

P.

Cуmo puedo usar TRegExpr con Borland C++ Builder?

Tengo un problema porque no hay un archivo de cabecera (.h or .hpp)
disponible.

R.

[TABLE]

[TABLE]

[TABLE]

[TABLE]

 

P.

Porquй TRegExpr devuelve mбs de una lнnea?

Por ejemplo, e.r. &lt;font .\*&gt; devuelve la primera lнnea &lt;font, y
entonces el resto del archivo incluso el ъltimo &lt;/html&gt;...

R.

Por compatibilidad con versiones anteriores el modificador /s estб
activado por defecto.

Desactivarlo y '.' encotrarб todo menos separadores de lнnea.

A propуsito, le sugiero '&lt;font (\[^\\n&gt;\]\*)&gt;', serб la URL en
Match\[1\].

 

P.

Porquй TRegExpr devuelve mбs de lo esperado?

Por ejemplo, la e.r. '&lt;p&gt;(.+)&lt;/p&gt;' aplicada a la cadena
'&lt;p&gt;a&lt;/p&gt;&lt;p&gt;b&lt;/p&gt;' devuelve
'a&lt;/p&gt;&lt;p&gt;b' pero no 'a' como esperaba.

R.

Por defecto, todos los operadores funcionan en modo 'voraz', entonces
devuelven lo mбximo posible.

Para operaciуn 'no voraz' se pueden usar operadores no voraces como '+?'
(nuevo en v. 0.940) o cambiar todos los operadores a modo 'no voraz' con
la ayuda del modificador 'g' (usando las propiedades de TRegExpr o
construcciones como '?(-g)' en la e.r.).

 

P.

Cуmo se pueden descomponer textos como HTML con la ayuda de TRegExpr

R.

Lo siento amigos, pero es prбcticamente imposible!

Por supuesto, se puede usar fбcilmente TRegExpr para extraer alguna
informaciуn del HTML, como se muestra en mis ejemplos, pero para
desomponer en forma precisa hay que usar un cуdigo real de
descomposiciуn, no e.r.!

Pueden obtener la explicaciуn completa en el libro 'Perl Cookbook' de
Tom Christiansen y Nathan Torkington. Brevemente, hay muchas
construcciones que sуn fбcilmente descompuestas por el programa
apropiado, pero en absoluto por una e.r., y un descomponedor real es
MUCHO mбs rбpido porque la e.r. no hace simplemente una bъsqueda,
incluye una optimizaciуn que puede llevar una gran cantidad de tiempo.

 

P.

Hay forma de obtener mъltiples coincidencias de una plantilla en
TRegExpr?

R.

Se puede hacer un bucle e iterar una por una con el mйtodo ExecNext.

No se puede hacer mбs fбcil porque Delphi no es un intйrprete como Perl
(y es un beneficio, los intйrpretes son muy lentos).

Para ver algъn ejemplo ver la implementaciуn del mйtodo
TRegExpr.Replace, o los ejemplos en
[HyperLinksDecorator.pas](#hyperlinksdecorator.html)

 

P.

Estoy controlando entradas de usuarios. Porquй TRegExpr devuelve 'True'
para cadenas incorrectas?

R.

En muchos casos los usuarios de TRegExpr olvidan que las expresiones
regulares son para BUSCAR en una cadena. Entonces, si se pretende que un
usuario ingrese sуlo 4 dнgitos y se usa para ello la expresiуn
'\\d{4,4}', se puede errar la detecciуn de parбmetros incorrectos como
'12345' o 'cualquier letra 1234 y cualquier otra cosa'. Hay que agregar
control para inicio y fin de lнnea para asegurarse de que no hay nada
alrededor: '^\\d{4,4}$'.

 

P.

Porquй los iteradores no voraces a veces funcionan como en modo voraz?

Por ejemplo, la e.r. 'a+?,b+?' aplicada a la cadena 'aaa,bbb' encuentra
'aaa,b', pero deberнa No encontrar 'a,b' a causa de la no voracidad del
primer iterador?

R.

Esta es la limitaciуn de las matemбticas usadas por TRegExpr (y de las
e.r. de Perl y muchos Unix) - e.r. realiza sуlo una optimizaciуn de
bъsqueda 'simple', y no trata de hacer la mejor optimizaciуn. En algunos
casos esto es malo, pero en los comunes es mayor la ventaja que la
limitaciуn - por motivos de rapidez y predecibilidad.

La regla principal - la e.r. antes que nada intenta encontrar
coincidencia desde la posiciуn actual y sуlo si es completamente
imposible avanzar un caracter e intentar nuevamente desde ese lugar.
Entonces, si se usa 'a,b+?' se encuentra 'a,b', pero en el caso de
'a+?,b+?' es 'no recomendado' (a causa de la no voracidad) pero posible
encontrar mбs de una 'a', entonces TRegExpr lo hace y finalmente obtiene
una correcta (pero no уptima) coincidencia. TRegExpr como las e.r. de
Perl o Unix no intenta avanzar y volver a chequear - lo que serнa una
'mejor' coincidencia. Mбs aъn, esto no puede ser comparado en absoluto
en tйrminos de 'mejor o pero coincidencia'.

Por favor, leer  la secciуn
'[Sintaxis](#regexp_syntax.html#engine_internals)' para una mayor
explicaciуn explanation.
