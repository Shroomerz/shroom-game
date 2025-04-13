***__Potraktujcie to na razie jako propozycję, najlepiej byłoby się spotkać i go razem omówić pokrytykować i ulepszyć.__***


# Dokumentacja klas wspólnych oraz interfejsów
Ten dokument jest tutaj po to, żeby pomóc nam we współpracy. Powinien zawierać możliwie aktualny opis klas oraz inerfejsów, które będą używane przez wszystkich.
## Interfejsy
### Wstęp
#### Motywacja
Ten dokument jest napisany po to, żeby ułatwić nam pracę w zespole. Znajdują się w nim opisy *interfejsów* - klas które będą stały na granicach pomiędzy modułami i które będziemy wykorzystywać do ich łączenia. Dzięki temu każdy będzie mógł samemu zaprojektować swój moduł, a jego architektura nie będzie miała wpływu na pracę innych.
#### Zasady odnośnie interfejsów
* Dodawanie nowych metod do interfejsów powinno być bardzo dobrze przemyślaną decyzją
* Tworzenie nowych interfejsów powinno być dobrze przemyślane i wynikać z obecnie istniejących potrzeb
* Modyfikowanie argumentów formalnych metody w interfejsie, lub jego zachowania powinno być ostatecznością, a jeśli już się to zdarzy to każdy członek zespołu powinien być o tym wyraźnie powiadomiony.
### Lista i opis interfejsów
#### Item
Reprezentuje przedmiot, który gracz może użyć, posiadać, lub z którego może zrobić miksturę
##### Metody:
* `create_world_entity() -> WorldEntity`
Zwraca byt reprezentujący przedmiot w świecie gry. Patrz `WorldEntity`
* `create_inventory_entity() -> InventoryEntity`
Zwraca byt reprezentujący przedmiot w ekwipunku. Patrz `InventoryEntity` 
* `is_usable() -> bool`
Tylko niektóre przedmioty można użyć. Ta metoda zwraca informację o tym, czy dany przedmiot jest używalny.
* `use() -> bool`
Zachowanie tej metody jest zależne od przedmiotu. Na przykład, mikstura lecząca przywraca punkty zdrowia. Jeżeli zwraca `true` to przedmiot powinien zostać usunięty po wykorzystaniu.
##### Uwagi:
* Żeby sprawdzać, czy Item jest jakiegoś podtypu, np. składnikiem mikstury można napisać:
``` GDscript
if item_object is Ingredient:
	print("item_object jest składnikiem lub podklasą składnika.")
```
#### WorldEntity
TODO: Ktoś kto zajmuje się światem, nie wiem co tu napisać
#### IngredientSpecies
##### Metody:
* `create_specimen(position: Vector2) -> Item`
Generuje grzyba / składnik mikstur danego gatunku, w zależności od *seed*'a sesji / rozgrywki oraz pozycji `position`.
#### EnemyEncounter
Ta klasa reprezentuje
##### Metody:
* `create_instance(position: Vector2) -> `
Ta funkcja powinna zwrcać listę / zbiór przeciwników lub w jakiś inny sposób dodawać generować losowe spotkanie w określnej przez *position* miejscu na mapie. Wygenerowani przeciwnicy powinni być wylosowani w zależności od seeda rozgrywki oraz pozycji.
TODO: Pabian i MasFlam, ustalcie już sobie jak to ma dokładnie wyglądać.
#### Enemy
TODO: Pabian i MasFlam, ustalcie sobie, czy ten interfejs jest w ogóle potrzebny i jak mają być przetrzymywani w świecie. Wydaje mi się, że powinni raczej stanowić dzieci świata.
## Klasy
### Wstęp
Opis klas, klas statycznych etc. `<<autoload>>` oznacza autoload'owaną klasę (zgodnie z dokumentacją Godota).
### Lista i opisy klas
#### InventoryEntity
TODO: Nie wiem, co tu napisać, może Stasiu będzie wiedział.
##### Metody:
* Tutaj jakaś metoda która zwraca referencję do itemu albo jego id w inverntory czy coś
#### Biome
Reprezentuje konkretny biom. Na pewno musi mieć metodę która pozwala innym klasom na proceduralne generowanie obiektów w zależności od biomu. Nie wiem jak te biomu ostatecznie są zaprojektowane, czy to będzie wektor jakichś własności tych biomów, czy zwykłe ID biomu. Ogólnie nie wiem za bardzo co tu napisać, więc TODO: ktoś inny xP
#### GameState
Klasa reprezentuje obecną rozgrywkę, zawiera:
* Seed'a obecnej sesji
* Obiekt SpeciesRegistry - spis obecnych gatunków
* Licznik dni
* Ekwipunek gracza
* Obecną planszę gry
##### Metody:
* `next_day()`
Metoda jest odpowiedzialna, za inkrementacje licznika dnia. Wygenerowanie nowych gatunków i dodanie ich do obiektu SpeciesRegistry. Wygenerowanie nowej planszy (TODO: MasFlam, opinia). 
* `get_current_day() -> int`
Zwraca obecny dzień rozgrywki
* `get_current_seed() -> int`
Zwraca obecny seed rozgrywki
* `get_inventory_reference() -> Inventory`
Zwraca referencję do obecnego ekwipunku gracza
* `new_gamestate()`
Generuje nową rozgrywkę
#### `<<autoload>>` EnemyRegistry
Klasa która ładuje się przy włączniu gry. Zawiera listę obiektów dziedziczących po EnemyEncounter. Jej główną funkcjonalnością jest losowanie EnemyEnounter'a dla danego biomu.
##### Metody:
* `get_random_encounter(position: Vector2, biome: Biome) -> EnemyEncounter`
Losuje jedno spotkanie dla danej pozycji i biomu. Losowanie powinno zależeć od `position`, `biome`, seeda GameState'a oraz obecnego dnia.
#### SpeciesRegistry
Klasa której obiekt trzymany jest w GameState. Przetrzymuje obecnie wygenerowane gatunki grzybów i pozwala na ich losowanie
##### Metody:
* `get_random_species(position: Vector2, biome: Biome) -> Species`
Zwraca losowy gatunek grzyba w zależności od biomu oraz pozycji w świecie.
* `generate_new_species(biome: Biome, current_species_count: int)`
Generuje nowy gatuenk grzyba dla biomu, tego ile gatunków już wygenerowano
## Uwagi
### Wykorzystanie pary `Vector2`, `Biome` oraz seed'a rozgrywki do losowej generacji
Jednym z wymagań naszej gry jest to, żeby dla jednego seed'a rozgrywki, generowana była ta sama rozgrywka. Dlatego do generacji bytów istniejących na planszy wykorzystujemy pozycję w której mają zostać wygenerowane i seeda obecnej rozgrywki. Gdybyśmy wykorzystali prostsze własności, takie jak czas generacji etc. do losowania to jego wynik zależałby od czasu generacji chunka, co nie spełaniałoby wymagań.
