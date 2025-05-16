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
* `is_stackable() -> bool`
Niektóre itemy pomimo bycia identycznymi nie powinny się agregować w ekwipunku ta metoda zwraca true jezeli item można agregować ze wz na pole itemID
##### Pola:
* `ID`
Zawiera identyfikator przedmiotu na podstawie którego odbywa się ich sortowanie oraz agregacja. ID ma postać dwóch członów oddzielonych symbolem `_` pierwszy człon to kategoria a drugi sluzy do rozroznienia itemów tej samej kategorii.
* `name`
zawiera tekstową nazwę przedmiotu
* `description`
Zawiera Opis Przedmiotu
* `type`
pole przyjmujące wartości "2d" lub "3d" decydujące o trybie wyświetlania itemów
* `usable`
pole wewnętrzne dla metody is_usable()
* `stackable`
pole wewnętrzne dla metody is_stackable()
##### Uwagi:
* Żeby sprawdzać, czy Item jest jakiegoś podtypu, np. składnikiem mikstury można napisać:
``` GDscript
if item_object is Ingredient:
	print("item_object jest składnikiem lub podklasą składnika.")
```
#### ItemStack
Reprezentuje agregację itemów
##### Metody:
* `get_item() -> Item`
zwraca przedmiot który jest agregowany
* `get_quantity() -> int`
zwraca ilość agregowanych przedmiotów
#### Inventory
Reprezentuje ekwipunek gracza
##### Metody:
* `get_id_by_id(ID:String) -> int`
zwraca numer indeksu stacku w ekwipunku agregującego item o identyfikatorze ID
 * `get_obj_by_item_id(ID:String) -> ItemStack`
zwraca stack agregujący w ekipunku item o identyfikatorze ID
* `get_obj_by_id(id:int) -> ItemStack`
zwraca obiekt ItemStack o indeksie id w ekwipunku
* `get_array() -> Array[ItemStack]`
zwraca obiekt tablicowy typów ItemStack który nie jest kopią tylko referencją do stanu faktycznego ekwipunku (niebezpieczne)
* `sort_cat() -> void`
sortuje ekwipunek zgodnie z opisem w klasie Item pole ID 
* `clear() -> void`
opróżnia ekwipunek
* `add_item(item:Item, quantity:int) -> void`
dodaje quantity itemów item do ekwipunku
* `remove_item(item:Item, quantity:int) -> bool`
usuwa quantity itemów Item z ekwipunku zwraca fałsz jeżeli itemu nie było w ekwipunku
* `get_size() -> void`
zwraca ilość indywidualnych itemów w ekwipunku (tzn get_size() add_item(x,30) get_size() wypisze dwie liczby równe sobie jezeli item x lub inny item o takim samym itemID był już w ekipunku, w przeciwnym wypadku wypisze liczby różne o 1)
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
#### `<<autoload>>` GameState
Klasa reprezentuje obecną rozgrywkę, zawiera:
* Seed'a obecnej sesji
* Obiekt SpeciesRegistry - spis obecnych gatunków
* Licznik dni
* Ekwipunek gracza
* Obecną planszę gry
##### Metody:
* `next_day() -> void`
Metoda jest odpowiedzialna, za inkrementacje licznika dnia. Wygenerowanie nowych gatunków i dodanie ich do obiektu SpeciesRegistry. Wygenerowanie nowej planszy (TODO: MasFlam, opinia). 
* `get_day() -> int`
Zwraca obecny dzień rozgrywki
* `get_board() -> Board`
Zwraca planszę świata obecnego dnia
* `get_inventory() -> Inventory`
Zwraca referencję do obecnego ekwipunku gracza
* `get_species_registry() -> SpeciesRegistry`
Zwraca rejestr gatunków grzybów
* `reset(game_seed: int)`
Czyści dotychczasowy stan gry i inicjalizuje na nowo z podanym seedem.
Służy również do inicjalizacji po raz pierwszy.
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
#### Specimen
Scena która reprezentuje jednego grzyba. Dziedziczy po Item'ie. W swoim drzewku ma swój model, kamerę do oglądania go oraz źródło światła więc można go wsadzać jako dziecko SubViewport'a i wyświetlać na planszy 2D.
## Uwagi
### Wykorzystanie pary `Vector2`, `Biome` oraz seed'a rozgrywki do losowej generacji
Jednym z wymagań naszej gry jest to, żeby dla jednego seed'a rozgrywki, generowana była ta sama rozgrywka. Dlatego do generacji bytów istniejących na planszy wykorzystujemy pozycję w której mają zostać wygenerowane i seeda obecnej rozgrywki. Gdybyśmy wykorzystali prostsze własności, takie jak czas generacji etc. do losowania to jego wynik zależałby od czasu generacji chunka, co nie spełaniałoby wymagań.
