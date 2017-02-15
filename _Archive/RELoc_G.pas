JS> Most of the iso-8559-1 Latin-1 or Win1250-Win1251 contain the 'German
JS> Umlauts'. They are '������' and '�' (only lowercase), and the
JS> paragraph '�' character.
JS> For iso-8559-1 (Western Latin 1) they are:

JS> Char.     Description            Name(HTML) Unicode(HTML)
JS> �         Paragraph-Character      &sect;          &#167;
JS> �         A Umlaut                 &Auml;          &#196;
JS> �         O Umlaut                 &Ouml;          &#214;
JS> �         U Umlaut                 &Uuml;          &#220;
JS> �         double s (ss)            &szlig;         &#223;
JS> �         a Umlaut                 &auml;          &#228;
JS> �         o Umlaut                 &ouml;          &#246;
JS> �         u Umlaut                 &uuml;          &#252;

JS> The Unicode-HTML is the same as the 8-bit code, so i don't really know
JS> if the Windows-Unicode is the same.

JS> Lowercase is: a�bcdefghijklmno�pqrs�tu�vwxyz
JS> Uppercase is: A�BCDEFGHIJKLMNO�PQRSTU�VWXYZ

JS> The Paragraph-Character isn't normally used as an alphacharacter.
