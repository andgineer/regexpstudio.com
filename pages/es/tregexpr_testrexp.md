---
layout: page
lang: es
ref: tregexpr_testrexp
title: Das Demo-Projekt (TestRExp)
permalink: /es/tregexpr_testrexp.html
---

Proyecto Demo (TestRExp)

 

Programa simple para explorar y probar e.r., distribuнda como cуdigo
fuente (proyecto TestRExp.dpr) y TestRExp.exe.

 

Nota: usa algunas propiedades de VCL que sуlo existen en Delphi 4 o
superior. Mientras se compila en Delphi 3 o Delphi 2 se recibirбn
mensajes de error acerca de propiedades desconocidas. Se pueden ignorar,
estas propiedades son sуlo para ajustar tamaсo y justificaciуn de
componentes cuando el formulario cambia su tamaсo.

 

Con la ayuda de este programa se puede determinar fбcilmente el nъmero
de subexpresiones, saltar a cualquiera de ellas (en el cуdigo de la e.r.
o en los resultados de la cadena exprorada), probar las funciones
Substitute, Replace y Split.

 

Ademбs se incluyen muchos ejemplos que se pueden usar mientras se
aprende la sintaxis de e.r. o en la exploraciуn rбpida de las
capacidades de TRegExpr.

Ejemplo: Hyper Links Decorator

Funciones para decorar hipervнnculos mientras se convierte texto puro en
HTML.

 

Por ejemplo, reemplaza 'http://anso.da.ru' con  '&lt;a
href="http://anso.da.ru"&gt;anso.da.ru&lt;/a&gt;' o 'anso@mail.ru' con
'&lt;a href="mailto:anso@mail.ru"&gt;anso@mail.ru&lt;/a&gt;'.

 

 

Funciуn DecorateURLs

Busca y reemplaza hipervнnculos como 'http://...' or 'ftp://..' asн como
vнnculos sin protocolo pero que comienzan con 'www.' Si quiere modificar
direcciones de correo electrуnico tiene que usar la funciуn
DecorateEmails (ver mбs abajo).

 

function DecorateURLs (const AText : string; AFlags :
TDecorateURLsFlagSet = \[durlAddr, durlPath\]) : string;

 

Descripciуn

 

Devuelve el texto AText con los hipervнnculos decorados.

 

AFlags indica quй parte del hipervнnculo debe ser incluнda en la parte
VISIBLE del link:

Por ejemplo, si el flag es \[durlAddr\] entonces el link
'http://anso.da.ru/index.htm' serб decorado como '&lt;a
href="http://anso.da.ru/index.htm"&gt;anso.da.ru&lt;/a&gt;'

 

type

 TDecorateURLsFlags = (durlProto, durlAddr, durlPort, durlPath,
durlBMark, durlParam);

 TDecorateURLsFlagSet = set of TDecorateURLsFlags;

 

Descripciуn

 

Estos son los valores posibles:

 

Valor                                Significado

 

 

 

durlProto                Protocolo (como 'ftp://' or 'http://')

durlAddr                Direcciуn TCP o nombre de dominio (como
'anso.da.ru')

durlPort                Nъmero de puerto, si estб especificado (como
':8080')

durlPath                Ruta al documento (como 'index.htm')

durlBMark                Book mark (como '\#mark')

durlParam                Parбmetros de la URL (como '?ID=2&User=13')

 

 

 

 

Funciуn DecorateEMails

 

Reemplaza todos los e-mails de sintaxis correcta con '&lt;a
href="mailto:ADDR"&gt;ADDR&lt;/a&gt;'. Por ejemplo, reemplaza
'anso@mail.ru' con '&lt;a
href="mailto:anso@mail.ru"&gt;anso@mail.ru&lt;/a&gt;'.

 

function DecorateEMails (const AText : string) : string;

 

Descripciуn

 

Devuelve el texto AText con los e-mails decorados.

