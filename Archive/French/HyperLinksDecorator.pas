{$B-}
unit HyperLinksDecorator;

{
 Exemple d'utilisation de TRegExpr:

 Fonction pour décorer les hyper liens pendant la conversion
 du texte standard en texte HTML.

 Par exemple, remplace 'http://anso.da.ru' avec
 '<a href="http://anso.da.ru">anso.da.ru</a>'
 ou 'anso@mail.ru' avec '<a href="mailto:anso@mail.ru">anso@mail.ru</a>'.

 Noter:
  Cette fonction à besoin d'être optimisée - Elle construit des chaînes
  de résultat avec une concaténation étape par étape qui peut prendre
  beaucoup de ressource pendant le traitement des grosses entrées avec
  plusieurs hyper liens.

 (c) 2000 Andrey V. Sorokin
  St-Petersburg
  Russia
  anso@mail.ru, anso@usa.net
  http://anso.da.ru
  http://anso.virtualave.net

  Version française par
   Martin Ledoux
   mledoux@citenet.net
   martinlmtl@hotmail.com
}

interface

uses
 RegExpr;

type
TDecorateURLsFlags = (
 // décris, quelle partie de l'hyper lien sera inclus
 // dans la partie VISIBLE du lien:
  durlProto, // Protocole (comme 'ftp://' ou 'http://')
  durlAddr,  // Adresse TCP address ou nom de domainee (comme 'anso.da.ru')
  durlPort,  // Numéro de port si spécifié (comme ':8080')
  durlPath,  // Chemin au document (comme 'index.htm')
  durlBMark, // Bookmark (comme '#mark')
  durlParam  // paramêtre URL (comme '?ID=2&User=13')
 );

TDecorateURLsFlagSet = set of TDecorateURLsFlags;

function DecorateURLs (
 // peut trouver les hyper liens comme 'http://...' or 'ftp://..'
 // aussi bien que ceux sans protocole, mais qui commence par 'www.'
 // Si vous voulez décorer les emails, vous devrez utiliser plutôt la
 // fonction DecorateEMails.
 const AText : string;
 // Texte d'entrée pour trouver les hyper liens.
  AFlags : TDecorateURLsFlagSet = [durlAddr, durlPath]
 // Quelle partie des hyper liens trouvés doit être inclus dans
 // la partie VISIBLE de l'url, par exemple si [durlAddr] l'hyper
 // lien 'http://anso.da.ru/index.htm' sera décoré comme
 // '<a href="http://anso.da.ru/index.htm">anso.da.ru</a>'
  ) : string;
 // Retourne le texte d'entré avec les décorations.


function DecorateEMails (
 // Remplace la syntaxe des emails
 // avec '<a href="mailto:ADDR">ADDR</a>'
 // par exemple, remplace 'anso@mail.ru'
 // avec '<a href="mailto:anso@mail.ru">anso@mail.ru</a>'.
 const AText : string
 // Texte d'entrée pour trouver les e-mails
  ) : string;
 // Retourne le texte d'entré avec les décorations.


implementation

uses
 SysUtils; // Nous utilisons AnsiCompareText.

function DecorateURLs (const AText : string;
  AFlags : TDecorateURLsFlagSet = [durlAddr, durlPath]
  ) : string; 
const 
  URLTemplate = 
   '(?i)' 
   + '(' 
   + '(FTP|HTTP)://' // Protocole
   + '|www\.)' // Dur de trouver les liens sans protocole (comme 'www.paycash.ru')
   + '([\w\d\-]+(\.[\w\d\-]+)+)' // adresse TCP / nom de domaine
   + '(:\d\d?\d?\d?\d?)?' // numéro de port
   + '(((/[%+\w\d\-\\\.]*)+)*)' // chemin style unix
   + '(\?[^\s=&]+=[^\s=&]+(&[^\s=&]+=[^\s=&]+)*)?' // paramètre demandés
   + '(#[\w\d\-%+]+)?'; // bookmark
var
  PrevPos : integer;
  s, Proto, Addr, HRef : string;
begin
  Result := ''; 
  PrevPos := 1; 
  with TRegExpr.Create do try 
     Expression := URLTemplate; 
     if Exec (AText) then 
      REPEAT 
        s := ''; 
        if AnsiCompareText (Match [1], 'www.') = 0 then begin
           Proto := 'http://';
           Addr := Match [1] + Match [3]; 
           HRef := Proto + Match [0];
          end
         else begin 
           Proto := Match [1]; 
           Addr := Match [3]; 
           HRef := Match [0]; 
          end; 
        if durlProto in AFlags 
         then s := s + Proto; // Match [1] + '://'; 
        if durlAddr in AFlags 
         then s := s + Addr; // Match [2]; 
        if durlPort in AFlags 
         then s := s + Match [5]; 
        if durlPath in AFlags 
         then s := s + Match [6]; 
        if durlParam in AFlags 
         then s := s + Match [9]; 
        if durlBMark in AFlags
         then s := s + Match [11]; 
        Result := Result + System.Copy (AText, PrevPos, 
         MatchPos [0] - PrevPos) + '<a href="' + HRef + '">' + s + ''; 
        PrevPos := MatchPos [0] + MatchLen [0]; 
      UNTIL not ExecNext; 
     Result := Result + System.Copy (AText, PrevPos, MaxInt); // Tail 
    finally Free; 
   end; 
end; { de la fonction DecorateURLs
--------------------------------------------------------------}

function DecorateEMails (const AText : string) : string;
 const
  MailTemplate =
   '[_a-zA-Z\d\-\.]+@[_a-zA-Z\d\-]+(\.[_a-zA-Z\d\-]+)+';
 var
  PrevPos : integer;
 begin
  Result := '';
  PrevPos := 1;
  with TRegExpr.Create do try
     Expression := MailTemplate;
     if Exec (AText) then
      REPEAT
        Result := Result + System.Copy (AText, PrevPos,
         MatchPos [0] - PrevPos) + '<a href="mailto:' + Match [0] + '">' + Match [0] + '</a>';
        PrevPos := MatchPos [0] + MatchLen [0];
      UNTIL not ExecNext;
     Result := Result + System.Copy (AText, PrevPos, MaxInt); // Tail
    finally Free;
   end;
 end; { de la fonction DecorateEMails
--------------------------------------------------------------}

{
Noter: Que vous pouvez aisément extraire n'importe quelle partie de URL
       (voir les paramètres de AFlags).
}

end.
