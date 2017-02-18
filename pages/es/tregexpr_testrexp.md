---
layout: page
lang: es
ref: tregexpr_testrexp
title: Proyecto Demo (TestRExp)
permalink: /es/tregexpr_testrexp.html
---

Programa simple para explorar y probar e.r., distribuída como cуdigo
fuente (proyecto TestRExp.dpr) y TestRExp.exe.

 

Nota: usa algunas propiedades de VCL que sуlo existen en Delphi 4 o
superior. Mientras se compila en Delphi 3 o Delphi 2 se recibirán
mensajes de error acerca de propiedades desconocidas. Se pueden ignorar,
estas propiedades son sуlo para ajustar tamaсo y justificaciуn de
componentes cuando el formulario cambia su tamaсo.

 

Con la ayuda de este programa se puede determinar fácilmente el número
de subexpresiones, saltar a cualquiera de ellas (en el cуdigo de la e.r.
o en los resultados de la cadena exprorada), probar las funciones
Substitute, Replace y Split.

 

Además se incluyen muchos ejemplos que se pueden usar mientras se
aprende la sintaxis de e.r. o en la exploraciуn rápida de las
capacidades de TRegExpr.

Ejemplo: Hyper Links Decorator

Funciones para decorar hipervínculos mientras se convierte texto puro en
HTML.

 

Por ejemplo, reemplaza 'http://anso.da.ru' con  '<a
href="http://anso.da.ru">anso.da.ru</a>' o 'anso@mail.ru' con
'<a href="mailto:anso@mail.ru">anso@mail.ru</a>'.

 

 

Funciуn DecorateURLs

Busca y reemplaza hipervínculos como 'http://...' or 'ftp://..' así como
vínculos sin protocolo pero que comienzan con 'www.' Si quiere modificar
direcciones de correo electrуnico tiene que usar la funciуn
DecorateEmails (ver más abajo).

 

function DecorateURLs (const AText : string; AFlags :
TDecorateURLsFlagSet = \[durlAddr, durlPath\]) : string;

 

Descripciуn

 

Devuelve el texto AText con los hipervínculos decorados.

 

AFlags indica qué parte del hipervínculo debe ser incluída en la parte
VISIBLE del link:

Por ejemplo, si el flag es \[durlAddr\] entonces el link
'http://anso.da.ru/index.htm' será decorado como '<a
href="http://anso.da.ru/index.htm">anso.da.ru</a>'

 

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

durlPort                Número de puerto, si está especificado (como
':8080')

durlPath                Ruta al documento (como 'index.htm')

durlBMark                Book mark (como '\#mark')

durlParam                Parámetros de la URL (como '?ID=2&User=13')

 

 

 

 

Funciуn DecorateEMails

 

Reemplaza todos los e-mails de sintaxis correcta con '<a
href="mailto:ADDR">ADDR</a>'. Por ejemplo, reemplaza
'anso@mail.ru' con '<a
href="mailto:anso@mail.ru">anso@mail.ru</a>'.

 

function DecorateEMails (const AText : string) : string;

 

Descripciуn

 

Devuelve el texto AText con los e-mails decorados.

