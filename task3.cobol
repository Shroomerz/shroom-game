1. Napisanie scenariuszy przypadków użycia wybranego przez nas systemu (na podstawie specyfikacji
wymagań z poprzedniego ćwiczenia). Każdy scenariusz przypadku użycia musi zawierać co najmniej
następujące elementy:
- Nazwę
- Warunki początkowe
- Warunki końcowe
- Scenariusz
Co jeszcze może zawierać scenariusz?
- opis "aktorów"
- scenariusz (przepływ / ścieżkę) alternatywny
- odnośnik(i) do konkretnego wymagania
- odnośnik(i) do innego scenariusza
- itd.
Jak to zrobić?
Polecam poradnik pani Laury Brandenburg jak pisać scenariusze przypadków użycia (czy przypadki
użycia po prostu):
https://www.bridging-the-gap.com/what-is-a-use-case/
Oraz video:
https://www.youtube.com/watch?v=RHdGn7WMWos


Przypadek użycia:
Opis:
Aktorzy:
Warunki wstępne:
Tabelka:

Wyjątki i scenariusze alternatywne:

Przypadek użycia: Rozpoczęcie nowej gry
Opis: Gracz powinien móc rozpocząć nową grę według własnej woli. Powinien mieć do wyboru co najmniej 3 save-y
Aktorzy: Gracz
Warunki wstępne: Gracz jest w menu głównym
Tabelka:
1. Gracz klika "Nowa gra"
2. System wyświetla menu wyboru save slot-a
3. Gracz wybiera pusty save slot
4. System inicjalizuje save-a
5. System uruchamia grę na nowym save file-u

Wyjątki i scenariusze alternatywne:
3.a Gracz wybiera niepustego save slota
=> System wyświetla okienko z pytaniem, czy gracz jest pewien o usunięciu wybranego save-a
4.a Gracz wybiera opcję "tak"
=> System usuwa save-a
=> System inicjalizuje nową grę na wybranym slocie
=> System uruchamia grę
4.b Gracz wybiera opcję "nie"
=> System przechodzi do kroku 2.

DISCLAIMER: PO ROZPOCZECIU GRY GRACZ JAKO AKTOR OZNACZA POSTAC GRACZA W GRZE 

Przypadek użycia: Zbieranie grzyba
Opis: Gracz powinien móc zbierać grzyby podczas eksploracji świata gry.
Aktorzy: Gracz
Warunki wstępne: Gracz znajduje się w pobliżu grzyba.

    1. Gracz podchodzi do grzyba.
    2. System wyświetla mechanizm infomrujący o możliwości zebrania grzyba.
    3. Gracz naciska przycisk interakcji.
    4. System dodaje grzyba do ekwipunku gracza.
    5. System usuwa grzyba z otoczenia.

Wyjątki i scenariusze alternatywne:
    brak

Przypadek użycia: Warzenie mikstury
Opis: Gracz powinien móc warzyć mikstury z zebranych grzybów.
Aktorzy: Gracz
Warunki wstępne: Gracz znajduje się w menu w chatce.

    1. Gracz wybiera menu craftowania  
    2. System wyświetla menu wyboru komponentów mikstury.
    3. Gracz wybiera
    4. System warzy miksturę i dodaje ją do ekwipunku.
    5. System usuwa użyte składniki z ekwipunku gracza.

Wyjątki i scenariusze alternatywne:
2.a System wyświetla komunikat „Brak składników”
=> System nie warzy mikstury

Przypadek użycia: Użycie mikstury / grzyba
Opis: Gracz powinien móc używać grzybów i mikstur (potencjalnie), które znajdują się w jego ekwipunku.
Aktorzy: Gracz
Warunki wstępne: Gracz posiada co najmniej jedną miksturę w ekwipunku.

    Gracz otwiera ekwipunek.
    System wyświetla listę posiadanych mikstur.
    Gracz wybiera miksturę i potwierdza użycie.
    System aktywuje efekt mikstury.
    System usuwa zużytą miksturę z ekwipunku.

Wyjątki i scenariusze alternatywne:
3.a Gracz próbuje użyć mikstury, gdy jej efekt już działa
=> System wyświetla komunikat „Efekt już aktywny”
=> System nie zużywa mikstury

Przypadek użycia: wznowienie stanu rozgrywki
Opis: Gracz powinien móc wrócić do gry po przerwie
Aktorzy: Gracz
Warunki wstępne: 

    Gracz otwiera ekwipunek.
    System wyświetla listę posiadanych mikstur.
    Gracz wybiera miksturę i potwierdza użycie.
    System aktywuje efekt mikstury.
    System usuwa zużytą miksturę z ekwipunku.

Wyjątki i scenariusze alternatywne:

Przypadek użycia: otwarcie menu w trakcie rozgrywki
Opis:
Aktorzy: Gracz
Warunki wstępne: 

    Gracz otwiera ekwipunek.
    System wyświetla listę posiadanych mikstur.
    Gracz wybiera miksturę i potwierdza użycie.
    System aktywuje efekt mikstury.
    System usuwa zużytą miksturę z ekwipunku.

Wyjątki i scenariusze alternatywne:


Przypadek użycia: wejście do chatki
Opis:
Aktorzy: Gracz
Warunki wstępne: 

    Gracz otwiera ekwipunek.
    System wyświetla listę posiadanych mikstur.
    Gracz wybiera miksturę i potwierdza użycie.
    System aktywuje efekt mikstury.
    System usuwa zużytą miksturę z ekwipunku.

Wyjątki i scenariusze alternatywne:


Przypadek użycia: wyjście z chatki
Opis:
Aktorzy: Gracz
Warunki wstępne: 

    Gracz otwiera ekwipunek.
    System wyświetla listę posiadanych mikstur.
    Gracz wybiera miksturę i potwierdza użycie.
    System aktywuje efekt mikstury.
    System usuwa zużytą miksturę z ekwipunku.

Wyjątki i scenariusze alternatywne:


Przypadek użycia: poruszanie się po mapie
Opis:
Aktorzy: Gracz
Warunki wstępne: 

    Gracz otwiera ekwipunek.
    System wyświetla listę posiadanych mikstur.
    Gracz wybiera miksturę i potwierdza użycie.
    System aktywuje efekt mikstury.
    System usuwa zużytą miksturę z ekwipunku.

Wyjątki i scenariusze alternatywne:


Przypadek użycia: atakowanie przeciwnika
Opis:
Aktorzy: Gracz
Warunki wstępne: 

    Gracz otwiera ekwipunek.
    System wyświetla listę posiadanych mikstur.
    Gracz wybiera miksturę i potwierdza użycie.
    System aktywuje efekt mikstury.
    System usuwa zużytą miksturę z ekwipunku.

Wyjątki i scenariusze alternatywne:


Przypadek użycia: pokonanie przeciwnika
Opis:
Aktorzy: Gracz
Warunki wstępne: 

    Gracz otwiera ekwipunek.
    System wyświetla listę posiadanych mikstur.
    Gracz wybiera miksturę i potwierdza użycie.
    System aktywuje efekt mikstury.
    System usuwa zużytą miksturę z ekwipunku.

Wyjątki i scenariusze alternatywne:


Przypadek użycia: otwarcie mapy
Opis:
Aktorzy: Gracz
Warunki wstępne: 

    Gracz otwiera ekwipunek.
    System wyświetla listę posiadanych mikstur.
    Gracz wybiera miksturę i potwierdza użycie.
    System aktywuje efekt mikstury.
    System usuwa zużytą miksturę z ekwipunku.

Wyjątki i scenariusze alternatywne:


Przypadek użycia: zmiana ustawień
Opis:
Aktorzy: Gracz
Warunki wstępne: 

    Gracz otwiera ekwipunek.
    System wyświetla listę posiadanych mikstur.
    Gracz wybiera miksturę i potwierdza użycie.
    System aktywuje efekt mikstury.
    System usuwa zużytą miksturę z ekwipunku.

Wyjątki i scenariusze alternatywne:


Przypadek użycia: wyjście z gry
Opis:
Aktorzy: Gracz
Warunki wstępne: 

    Gracz otwiera ekwipunek.
    System wyświetla listę posiadanych mikstur.
    Gracz wybiera miksturę i potwierdza użycie.
    System aktywuje efekt mikstury.
    System usuwa zużytą miksturę z ekwipunku.

Wyjątki i scenariusze alternatywne:


Przypadek użycia: przeglądanie katalogu grzybów
Opis:
Aktorzy: Gracz
Warunki wstępne: 

    Gracz otwiera ekwipunek.
    System wyświetla listę posiadanych mikstur.
    Gracz wybiera miksturę i potwierdza użycie.
    System aktywuje efekt mikstury.
    System usuwa zużytą miksturę z ekwipunku.

Wyjątki i scenariusze alternatywne:


Przypadek użycia: zmiana nazwy gatunku grzybów
Opis:
Aktorzy: Gracz
Warunki wstępne: 

    Gracz otwiera ekwipunek.
    System wyświetla listę posiadanych mikstur.
    Gracz wybiera miksturę i potwierdza użycie.
    System aktywuje efekt mikstury.
    System usuwa zużytą miksturę z ekwipunku.

Wyjątki i scenariusze alternatywne:


Przypadek użycia: dedukowanie gatunków grzybów przez gracza
Opis:
Aktorzy: Gracz
Warunki wstępne: 

    Gracz otwiera ekwipunek.
    System wyświetla listę posiadanych mikstur.
    Gracz wybiera miksturę i potwierdza użycie.
    System aktywuje efekt mikstury.
    System usuwa zużytą miksturę z ekwipunku.

Wyjątki i scenariusze alternatywne:


      
2. Wykonanie diagramu (diagramów) przypadków użycia (reprezentującego specyfikację wymagań
funkcjonalnych sporządzoną w poprzednim ćwiczeniu) na podstawie scenariuszy z punktu pierwszego.
Do tego celu należy użyć języka UML. Może być jeden ogromniasty diagram dla wszystkich przypadków
lub też osobne diagramy dla każdego przypadku. Czasami lepiej jest wybrać pierwszą opcję, czasami
drugą, w zależności, jakie wymagania odnośnie systemu macie.
Jak to zrobić?
Zacznijmy od przypomnienia jak za pomocą Zmumifikowanego Języka Modelowania popełnić diagram
przypadków użycia:
https://www.youtube.com/watch?v=yFVIBQcEl3w
W kolejnym kroku należy znaleźć sobie narzędzie do pracy z językiem UML, które będzie nam najlepiej
"leżeć".
Genialny serwis guru99 przygotował cały, całkiem fajny "UML Tutorial", który polecam, ale tutaj skupię
sie tylko na fragmencie, gdzie zgromadzono różne programy do pracy z UML - do wyboru, do koloru,
co komu odpowiada:
https://www.guru99.com/best-uml-tools.html
Jakich narzędzi użyć?
Online – spoczko jest https://app.diagrams.net/
Offline – w uczciwej cenie (między Bogiem a prawdą) jest DIA:
http://dia-installer.de/
(albo sudo apt install dia)
Jeśli ktoś z Was zdecyduje się na aplikację DIA, oto video pokazujące jak w niej tworzyć diagramy
przypadków użycia:
https://www.youtube.com/watch?v=zU1Tqwt6ios
...i tym samym mamy zrobioną drugą część ćwiczenia.
