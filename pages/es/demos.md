---
layout: page
lang: es
ref: demos
title: Cуmo funciona
permalink: /es/demos.html
---

### Ejemplos simples

Si no tiene experiencia con las expresiones regulares, por favor vea la
secciуn [sintaxis](#regexp_syntax.html).

### Usando las rutinas globales

Es simple pero poco flexible y efectivo

    ExecRegExpr ('\\d{3}-(\\d{2}-\\d{2}|\\d{4})', 'Telйfono: 555-1234');

devuelve True

    ExecRegExpr ('^\\d{3}-(\\d{2}-\\d{2}|\\d{4})', 'Telйfono: 555-1234');

devuelve False, porque hay algunos sнmbolos antes del nъmero de telйfono
y estamos usando el metasнmbolo '^' (BeginningOfLine = Inicio de lнnea)

ReplaceRegExpr ('producto', 'Pruebe producto. producto es el mejor !',
'TRegExpr');

devuelve 'Pruebe TRegExpr. TRegExpr es el mejor !'; ;)

### Usando la clase TRegExpr

Se obtiene todo el poder de la librerнa

{% highlight pascal linenos %}
// Esta simple funciуn extrae todas las direcciones de email de la cadena ingresada
// y devuelve una lista de estos email en el resultado
function ExtraeEmails (const AInputString : string) : string;
const
         EmailRE ='\[\_a-zA-Z\\d\\-\\.\]+@\[\_a-zA-Z\\d\\-\]+(\\.\[\_a-zA-Z\\d\\-\]+)+'
var
         r : TRegExpr;
begin
         Result := '';
         r := TRegExpr.Create; // Crea el objeto
         try // asegura la liberaciуn de memoria
                         r.Expression := EmailRE;
                         // La e.r. se compila automбticamente en estructuras internas
                         // cuando se asigna la propiedad Expression
                         if r.Exec (AInputString) then
                                         REPEAT
                                                         Result := Result + r.Match \[0\] + ', ';
                                         UNTIL not r.ExecNext;
                         finally r.Free;
         end;
end;
begin
         ExtraeEmails ('Mis e-mails son anso@mail.ru y anso@usa.net');
         // devuelve 'anso@mail.ru, anso@usa.net, '
end.
// Nota: la compilaciуn de la r.e. realizada al asignar ;a propiedad Expression
// toma cierto tiempo, si se usa esta funciуn muchas veces
// se sobrecarga inъtilmente.
// Esto se puede optimizar significativamente creando el objeto TRegExpr
// y precompilando la expresiуn durante la inicializaciуn del programa.
{% endhighlight %}
 
{% highlight pascal linenos %}
// Este ejemplo extrae nъmeros de telйfono
// y los descompone en partes (cуdigos de Ciudad y paнs, nъmerotelefуnico                ).
// Despuйs substituye estas partes en la mбscara ingresada.
function ParseTel (const AInputString, ATemplate : string) : string;
const
         IntPhoneRE = '(\\+\\d \*)?(\\(\\d+\\) \*)?\\d+(-\\d\*)\*';
var
         r : TRegExpr;
begin
         r := TRegExpr.Create; // Crea el objeto
         try // asegura la liberaciуn de memoria
                         r.Expression := IntPhoneRE;
                         // La e.r. se compila automбticamente en estructuras internas
                         // cuando se asigna la propiedad Expression
                         if r.Exec (AInputString)
                                         then Result := r.Substitute (ATemplate)
                                         else Result := '';
                         finally r.Free;
         end;
end;
begin
         ParseTel ('El telйfono de AlkorSoft (proyecto PayCash) es +7(812) 329-44-69',
         'Cуdigo de Paнs $1, cуdigo de ciudad $2. El nъmero telefуnico completo es $&.');
         // devuelve 'Cуdigo de Paнs +7, cуdigo de ciudad (812) . El nъmero telefуnico completo es +7(812) 329-44-69.'
end.
{% endhighlight %}


### Ejemplos mбs complejos

Se pueden encontrar ejemplos mбs complejos del uso de TRegExpr en el
proyecto [TestRExp.dpr](#tregexpr_testrexp.html) y
[HyperLinkDecorator.pas](#hyperlinksdecorator.html).

Ver tambiйn mis artнculos en
[Delphi3000.com](%60http://www.delphi3000.com/member.asp?ID=1300',%60',1,%60')
(Inglйs) y [Delphi
Kingdom](%60http://delphi.vitpc.com/mastering/strings_birds_eye_view.htm',%60',1,%60')
(Ruso).

 

### Explicaciуn detallada

Por favor, ver la [descripcion](#tregexpr_interface.html) de la
interface de TRegExpr.
