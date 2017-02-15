---
layout: page
lang: ru
ref: demos
title: Demos
permalink: /ru/demos.html
---

Демо-примеры
============

Здесь перечислены демо-проекты, иллюстрирующие основные приемы
использования TRegExpr.

 

Обратите внимание, что существуют локализованные варианты (с
комментариями на разных языках). Если у Вас в каталоге Demos примеры с
комментариями только на английском, то русскоязычные

Вы можете найти в составе полного русского дистрибутива TRegExpr или в
архиве с русской документацией (при распаковке архива в каталог
TRegExpr, русифицированные примеры записываются поверх английских,
замещая их).

 

Demos\\TRegExprRoutines

Самый простой способ использовать TRegExpr, пояснения см.в исходных
текстах.

 

Demos\\TRegExprClass

Более эффективный способ использовать TRegExpr, пояснения см.в исходных
текстах.

 

Demos\\Text2HTML

см. [описание](#text2html.html)

 

Если Вы не знакомы с регулярными выражениями, изучите раздел
[Синтаксис](#regexp_syntax.html). Кроме того, для понимания примеров
нужно просмотреть описание [интерфейса](#tregexpr_interface.html)
TRegExpr.

 

Не забудьте также прочитать мои статьи на
[Delphi3000.com](http://www.delphi3000.com/member.asp?ID=1300) (только
на английском) и [Королевстве
Delphi](http://delphi.vitpc.com/mastering/strings_birds_eye_view.htm), и
проголосовать там за эти статьи ;).

 

Примечание

Обратите внимание, что если Вы используете Delphi версии 3 и ниже, то
при открытии этого проекта Вы получите серию предупреждений о
несуществующих свойствах. Это не нарушит работу программы (речь идет о
расширениях, появившихся в Delphi 4 и позволяющих более интеллектуально
изменять размеры и положение компонентов при изменении размеров
содержащей их формы).

 

 

 

Text2Http
=========

Простейшая утилита для конвертации текста в HTML-код.

Использует модуль [HyperLinksDecorator](#hyperlinksdecorator.html)

 

Написана исключительно как пример использования TRegExpr.

 

Модуль оформления гипер-ссылок
==============================

[DecorateURLs](#hyperlinksdecorator.html#decorateurls)   [DecorateEMails](#hyperlinksdecorator.html#decorateemails)
===================================================================================================================

Содержит функции для поиска URL в обычном тексте и оформления их как
HTML-ссылки (используется в программе преобразования текста, в
 HTML-код, [Text2Html](#text2html.html)).

 

Например, подстрока 'www.RegExpStudio.com' будет заменена на '&lt;a
href="http://www.RegExpStudio.com"&gt;www.RegExpStudio.com&lt;/a&gt;', а
подстрока 'anso@mail.ru' заменится на '&lt;a
href="mailto:anso@mail.ru"&gt;anso@mail.ru&lt;/a&gt;'.

 

function DecorateURLs

 

Оформляет ссылки найденные как по сигнатуре 'http://...' или 'ftp://..'
так и ссылки в которых протокол не указан, но они начинаются с 'www.'
Прим. если нужно также оформить как ссылки e-mail адреса, воспользуйтесь
функцией [DecorateEMails](#hyperlinksdecorator.html#decorateemails).

 

function DecorateURLs (const AText : string; AFlags :
TDecorateURLsFlagSet = \[durlAddr, durlPath\]) : string;

 

Описание

 

Возвращает текст AText с оформленными гипер-ссылками.

 

AFlags определяет, какая часть гипер-ссылки будет помещена в видимую
часть. Например, если указать \[durlAddr\] то гипер-ссылка
'www.RegExpStudio.com/contacts.htm' будет оформлена как '&lt;a
href="http://www.RegExpStudio.com/contacts.htm"&gt;www.RegExpStudio.com&lt;/a&gt;'.

 

type

 TDecorateURLsFlags = (durlProto, durlAddr, durlPort, durlPath,
durlBMark, durlParam);

 TDecorateURLsFlagSet = set of TDecorateURLsFlags;

 

Описание

 

Возможные значения:

 

Значение        Описание

------------------------------------------------------------------------

durlProto        Протокол ('ftp://' или 'http://')

durlAddr        TCP адрес или доменное имя сервера (например,
'anso.da.ru')

durlPort                Номер порта, если указан  (например, ':8080')

durlPath        Путь к файлу (например, 'index.htm')

durlBMark        Закладка (например, '\#mark')

durlParam        URL-параметры (например, '?ID=2&User=13')

 

 

 

 

function DecorateEMails

 

Заменяет все обнаруженные адреса e-mails на гипер-ссылки вида '&lt;a
href="mailto:ADDR"&gt;ADDR&lt;/a&gt;'. Например, адрес 'anso@mail.ru'
будет заменен на '&lt;a
href="mailto:anso@mail.ru"&gt;anso@mail.ru&lt;/a&gt;'.

 

 

function DecorateEMails (const AText : string) : string;

 

Описание

 

Возвращает текст AText с оформленными как гипер-ссылки адресами e-mails

 

 
