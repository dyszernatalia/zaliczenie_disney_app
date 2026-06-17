# Disney Characters App

## Opis projektu

Disney Characters App to aplikacja mobilna stworzona w technologii Flutter. Projekt wykorzystuje Disney API do pobierania informacji o postaciach oraz SQLite do lokalnego przechowywania ulubionych postaci.

Aplikacja umożliwia przeglądanie postaci Disneya, wyświetlanie szczegółowych informacji o nich oraz zapisywanie wybranych bohaterów do listy ulubionych.

---

## Funkcjonalności

- Pobieranie danych z Disney API
- Wyświetlanie listy postaci Disneya
- Wyświetlanie szczegółów postaci
- Prezentacja filmów, seriali i gier związanych z postacią
- Dodawanie postaci do ulubionych
- Usuwanie postaci z ulubionych
- Lokalne przechowywanie danych w SQLite
- Nawigacja pomiędzy ekranami aplikacji

---

## Wykorzystane technologie

- Flutter
- Dart
- Disney API
- SQLite (sqflite)
- HTTP
- Material Design 3

---

## Struktura aplikacji

### Postacie

Ekran główny aplikacji prezentujący listę postaci pobranych z Disney API.

### Szczegóły postaci

Ekran wyświetlający:

- zdjęcie postaci,
- nazwę postaci,
- filmy,
- seriale,
- gry związane z postacią.

### Ulubione

Ekran zawierający postacie zapisane przez użytkownika w lokalnej bazie danych SQLite.

### O aplikacji

Ekran zawierający podstawowe informacje o projekcie i wykorzystanych technologiach.

---

## Baza danych SQLite

Aplikacja wykorzystuje lokalną bazę danych SQLite do przechowywania ulubionych postaci.

Tabela favorites przechowuje:

- id postaci,
- nazwę postaci,
- adres URL zdjęcia.

---

## Uruchomienie projektu

1. Sklonuj repozytorium.
2. Uruchom polecenie:

bash flutter pub get

3. Uruchom aplikację:

bash flutter run

---

## Autor

Natalia Dyszer

Projekt wykonany w ramach zaliczenia przedmiotu Flutter.