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

Przypadek użycia:
Opis:
Aktorzy:
Warunki wstępne:
Tabelka:
Wyjątki i scenariusze alternatywne:

Przypadek użycia: Rozpoczęcie nowej gry
Opis: Gracz powinien móc rozpocząć nową grę według własnej woli. Powinien mieć do wyboru co najmniej 3 save-y.
Aktorzy: Gracz
Warunki wstępne: Gracz jest w menu głównym
    1. Gracz klika "Nowa gra" 
    2. System wyświetla menu wyboru save slot-a 
    3. Gracz wybiera pusty save slot 
    4. System inicjalizuje save-a 
    5. System uruchamia grę na nowym save file-u 
Scenariusze alternatywne:
Gracz wybiera niepusty save slot. System wyświetla okienko z pytaniem, czy gracz jest pewien o usunięciu wybranego save-a. Jeśli gracz wybiera opcję "tak", system usuwa save-a, inicjalizuje nową grę na wybranym slocie i uruchamia grę. Jeśli gracz wybiera opcję "nie", system przechodzi do wyboru save slot-a.

Przypadek użycia: Zbieranie grzyba
Opis: Gracz powinien móc zbierać grzyby podczas eksploracji świata gry.
Aktorzy: Gracz
Warunki wstępne: Gracz znajduje się w pobliżu grzyba
    1. Gracz podchodzi do grzyba 
    2. System wyświetla mechanizm informujący o możliwości zebrania grzyba 
    3. Gracz naciska przycisk interakcji 
    4. System dodaje grzyba do ekwipunku gracza 
    5. System usuwa grzyba z otoczenia 
Scenariusze alternatywne:
Gracz próbuje zebrać grzyba, ale ekwipunek jest pełny. System wyświetla komunikat „Brak miejsca w ekwipunku” i nie dodaje grzyba.

Przypadek użycia: Warzenie mikstury
Opis: Gracz powinien móc warzyć mikstury z zebranych grzybów.
Aktorzy: Gracz
Warunki wstępne: Gracz znajduje się w chatce i otworzył menu craftingu
    1. Gracz wybiera menu craftowania 
    2. System wyświetla menu wyboru komponentów mikstury 
    3. Gracz wybiera składniki 
    4. System warzy miksturę i dodaje ją do ekwipunku 
    5. System usuwa użyte składniki z ekwipunku gracza 
Scenariusze alternatywne:
Gracz próbuje stworzyć miksturę, ale nie ma wymaganych składników. System wyświetla komunikat „Brak składników” i nie warzy mikstury.

Przypadek użycia: Użycie mikstury lub grzyba
Opis: Gracz powinien móc używać grzybów i mikstur, które znajdują się w jego ekwipunku.
Aktorzy: Gracz
Warunki wstępne: Gracz posiada co najmniej jedną miksturę lub grzyba w ekwipunku
    1. Gracz otwiera ekwipunek 
    2. System wyświetla listę posiadanych mikstur i grzybów 
    3. Gracz wybiera przedmiot i potwierdza użycie 
    4. System aktywuje efekt przedmiotu 
    5. System usuwa zużytą miksturę lub grzyba z ekwipunku 
Scenariusze alternatywne:
Gracz próbuje użyć mikstury, gdy jej efekt już działa. System wyświetla komunikat „Efekt już aktywny” i nie zużywa mikstury.

Przypadek użycia: Wczytanie stanu rozgrywki
Opis: Gracz powinien móc wrócić do gry po przerwie.
Aktorzy: Gracz
Warunki wstępne: Gracz znajduje się w menu głównym i ma zapisany stan gry
    1. Gracz klika "Continue”
    2. System wyświetla menu wyboru save slota
    3. Gracz wybiera save slota 
    4. System uruchamia rozgrywkę od miejsca zapisu 
Scenariusze alternatywne:

Przypadek użycia: Otworzenie menu pauzy w trakcie rozgrywki
Opis: Gracz powinien móc otworzyć menu, aby uzyskać dostęp do różnych opcji.
Aktorzy: Gracz
Warunki wstępne: Gracz znajduje się w trakcie rozgrywki
    1. Gracz naciska przycisk menu 
    2. System wyświetla menu pauzy 
Scenariusze alternatywne:
Brak

Przypadek użycia: Opuszczenie menu pauzy
Opis: Gracz powinien móc opuścić menu, aby wrócić do gry.
Aktorzy: Gracz
Warunki wstępne: Gracz znajduje się w menu pauzy
    3. Gracz naciska przycisk menu 
    4. System zamyka menu pauzy
Scenariusze alternatywne:
Brak

Przypadek użycia: Wejście do chatki
Opis: Gracz powinien móc wejść do chatki, jeśli znajduje się w pobliżu.
Aktorzy: Gracz
Warunki wstępne: Gracz stoi przy wejściu do chatki
    1. Gracz naciska przycisk interakcji 
    2. System przełącza widok na wnętrze chatki 
Scenariusze alternatywne:
brak

Przypadek użycia: Wyjście z chatki - nowy dzień
Opis: Gracz powinien móc wyjść z chatki do świata gry każdego dnia gry
Aktorzy: Gracz
Warunki wstępne: Gracz znajduje się w chatce
    1. Gracz naciska przycisk wyjścia 
    2. System generuje nowy świat gry
    3. System przełącza widok na świat zewnętrzny który się zmienił w stosunku do dnia poprzedniego
    ...(wiele różnych przypadków użycia może się odbyć w międzyczasie)
    n. gracz wraca do chatki
Scenariusze alternatywne:
n.a jeżeli gracz nie wróci do domu zanim zrobi się odpowiednio późno zabije go jakiś straszny potwór

Przypadek użycia: Przemieszczanie się po mapie
Opis: Gracz powinien móc swobodnie poruszać się po mapie gry.
Aktorzy: Gracz
Warunki wstępne: Gracz znajduje się w świecie gry
    1. Gracz używa klawiszy ruchu lub kontrolera 
    2. System przesuwa postać zgodnie z kierunkiem ruchu 
Scenariusze alternatywne:
Gracz napotyka przeszkodę nie do przejścia. System uniemożliwia dalszy ruch w tym kierunku.

Przypadek użycia: Atakowanie przeciwnika
Opis: Gracz powinien móc zaatakować przeciwnika w zasięgu ataku.
Aktorzy: Gracz, Przeciwnik
Warunki wstępne: Gracz znajduje się w pobliżu przeciwnika
    1. Gracz naciska przycisk ataku 
    2. System odtwarza animację ataku 
    3. System sprawdza czy atak trafia
    4. Jeśli atak trafił, system odejmuje przeciwnikowi punkty życia 
    5. Przeciwnik "łapie agro" na gracza
Scenariusze alternatywne:
Gracz atakuje, ale nie trafia. System nie odejmuje przeciwnikowi punktów życia.

Przypadek użycia: Pokonanie przeciwnika
Opis: Po pokonaniu przeciwnika gracz otrzymuje nagrody.
Aktorzy: Gracz, Przeciwnik
Warunki wstępne: Przeciwnik ma 0 punktów życia
    1. Przeciwnik odtwarza animację śmierci 
    2. System dodaje nagrody do ekwipunku gracza 
    3. System usuwa przeciwnika z otoczenia 
Scenariusze alternatywne:
Brak

Przypadek użycia: Przeglądanie katalogu grzybów
Opis: Gracz powinien móc sprawdzić informacje o znalezionych grzybach.
Aktorzy: Gracz
Warunki wstępne: Gracz zkatalogował co najmniej jeden gatunek grzyba
    1. Gracz otwiera katalog grzybów 
    2. System wyświetla listę odkrytych gatunków 
Scenariusze alternatywne:
Gracz nie odkrył żadnych grzybów. System wyświetla pustą listę.

Przypadek użycia: określanie gatunków grzybów przez gracza
Opis: Gracz powinien móc na podstawie swoich obserwacji określać gatunki grzybów i zapisywać swoje spostrzeżenia w katalogu
Aktorzy: Gracz
Warunki wstępne: Gracz znajduje się w menu katalogu

1. Gracz wybiera interesującego go grzyba
2. Gracz klika na guzik "określ gatunek"
3. System wyświetla menu określenia gatunku
4. Gracz wybiera gatunek z listy lub dodaje nową nazwę
5. System przypisuje gatunek grzybowi


Wyjątki i scenariusze alternatywne:
5.a Gracz dodał nazwę, która już istnieje
 => System wyświetla informację o błędzie i pozwala graczowi jeszcze raz wybrać nazwę


      
2. Wykonanie diagramu (diagramów) przypadków użycia (reprezentującego specyfikację wymagań
funkcjonalnych sporządzoną w poprzednim ćwiczeniu) na podstawie scenariuszy z punktu pierwszego.
Do tego celu należy użyć języka UML. Może być jeden ogromniasty diagram dla wszystkich przypadków
lub też osobne diagramy dla każdego przypadku. Czasami lepiej jest wybrać pierwszą opcję, czasami
drugą, w zależności, jakie wymagania odnośnie systemu macie.

@startuml
left to right direction
actor Gracz
rectangle system{
    usecase "Rozpoczęcie nowej gry" as UC1
    usecase "Otwarcie menu pauzy" as UC2
    usecase "Zamknięcie menu pauzy" as UC3
    usecase "Wznowienie rozgrywki" as UC4
}
rectangle aktywna_rozgrywka{
    usecase "Zbieranie grzyba" as UC5
    usecase "Użycie mikstury/grzyba" as UC7
    usecase "Wejście do chatki" as UC8
    usecase "Wyjście z chatki" as UC9
}
rectangle alchemia{
    usecase "Przeglądanie katalogu grzybów" as UC10
        usecase "Warzenie mikstury" as UC6
}

rectangle walka{
    usecase "Atakowanie przeciwnika" as UC11
    usecase "Pokonanie przeciwnika" as UC12
}
actor Gra
Gracz --> UC1
Gracz --> UC2
Gracz --> UC3
Gracz --> UC4
Gracz --> UC5
Gracz --> UC6
Gracz --> UC7
Gracz --> UC8
Gracz --> UC9
Gracz --> UC10
Gracz --> UC11
Gracz --> UC12
UC1 --> Gra
UC2 --> Gra
UC3 --> Gra
UC4 --> Gra
UC5 --> Gra
UC6 --> Gra
UC7 --> Gra
UC8 --> Gra
UC9 --> Gra
UC10 --> Gra
UC11 --> Gra
UC12 --> Gra
UC12 --> Gra
@enduml



 usecase "Pokonanie przeciwnika" as UC12

