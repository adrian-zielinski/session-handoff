<!-- markdownlint-disable MD033 -->
<h1 align="center">Session Handoff</h1>

<p align="center">
  <b>Pamięć tematyczna między sesjami Claude Code.</b><br>
  Zamknij sesję w połowie zadania, otwórz nową jutro i zacznij z pełnym rozbiegiem.
</p>

<p align="center">
  🇵🇱 <b>Polski</b> · <a href="README.en.md">🇬🇧 English</a>
</p>

---

## Problem

Sesja Claude Code kończy się razem z kontekstem. Otwierasz nową i tłumaczysz wszystko od zera: co już zrobione, jakie decyzje zapadły, dlaczego jedno podejście odpadło.

Auto-`/compact` tego nie ratuje. Odpala się dopiero przy pełnym kontekście, kiedy model jest już przytępiony, i robi streszczenie streszczeń. To, co zostaje, jest streszczeniem ostatniej sesji, a nie wiedzą zebraną z dziesięciu.

## Rozwiązanie

Kontekst mieszka w folderze `HANDOFF/` w rocie projektu. **Jeden plik `.md` = jeden temat**, plus `INDEX.md` ze spisem tematów.

```
HANDOFF/
  INDEX.md          # spis tematów, zawsze czytany pierwszy
  elevenlabs.md     # jeden temat = jeden plik
  followupy.md
  onboarding.md
```

Pod koniec pracy piszesz `/handoff`. Sesja dopisuje swój wkład do pliku **właściwego tematu**, nie do kolejnego pliku per sesja. Następnym razem piszesz `/pickup`, a nowa sesja czyta indeks plus jeden plik tematu i dostaje skompresowaną wiedzę z wielu poprzednich sesji naraz.

Plik tematu to żywy dokument, nie log. Przy zapisie sesja aktualizuje sekcje, usuwa to, co się zdezaktualizowało, i dokłada jedną linię do dziennika. Decyzje z uzasadnieniem zostają najdłużej, bo to one są know-how.

## Czym to się różni od handoffów per sesja

Zapisywanie kontekstu na koniec sesji to znany pomysł i większość rozwiązań robi to tak samo: koniec pracy, nowy plik `2026-08-12-refaktor-api.md`, następnym razem kolejny. Sam tak miałem przez pół roku. Po dwóch miesiącach leży 40 plików, ta sama decyzja występuje w pięciu wersjach z różnych tygodni, a nowa sesja nie wie, który plik otworzyć. Zwykle nie otwiera żadnego.

Tutaj plik należy do **tematu, nie do dnia**. Sesja dopisuje się do pliku istniejącego tematu: aktualizuje stan, usuwa to, co przestało obowiązywać, dokłada jedną linię do dziennika. Liczba plików rośnie z liczbą tematów w projekcie, a nie z liczbą sesji. Plik tematu jest zawsze najświeższą wersją wiedzy, nie archiwum, po które trzeba kopać.

Trzy rzeczy pilnują, żeby to się nie rozjechało:

1. **`INDEX.md` czytany zawsze pierwszy.** Mówi, jakie tematy istnieją i czym się różnią, więc sesja nie zakłada trzeciego pliku o tym samym.
2. **Temat dobierany po mechanizmie pracy, nie po nazwie sesji.** „Poprawa głosówek" trafia do tematu `elevenlabs`, choć nikt nie wymówił tego słowa.
3. **Limit około 150 linii.** Wymusza kondensację. Wtedy wychodzi, co jest know-how (decyzje z uzasadnieniem, ślepe uliczki), a co było tylko stanem na wtorek.

## Instalacja

### Wariant A: plugin (zalecany)

W sesji Claude Code:

```
/plugin marketplace add adrian-zielinski/session-handoff
```

```
/plugin install session-handoff@session-handoff
```

Aktualizacja do nowszej wersji, kiedy tylko wyjdzie:

```
/plugin update session-handoff
```

### Wariant B: skrypt instalacyjny

Kopiuje skill i komendy do `~/.claude/` (dostępne we wszystkich projektach):

```bash
git clone https://github.com/adrian-zielinski/session-handoff.git && cd session-handoff && ./install.sh
```

Później aktualizujesz przez `git pull && ./install.sh`.

### Wariant C: ręcznie

```
skills/session-handoff/SKILL.md  →  ~/.claude/skills/session-handoff/SKILL.md
commands/handoff.md              →  ~/.claude/commands/handoff.md
commands/pickup.md               →  ~/.claude/commands/pickup.md
```

Zamiast `~/.claude/` możesz użyć `.claude/` w konkretnym projekcie, jeśli chcesz mieć to tylko tam.

## Użycie

| Komenda | Co robi |
|---|---|
| `/handoff` | Zapisuje kontekst sesji do pliku tematu. Temat dobiera sam po tym, czego dotyczyła praca. |
| `/handoff elevenlabs` | To samo, ale temat wskazujesz ty. Twoje wskazanie wygrywa z auto-dopasowaniem. |
| `/pickup` | Pokazuje listę tematów ze statusami i pyta, który podnieść. |
| `/pickup followupy` | Wznawia konkretny temat od razu. |

Możesz też napisać zwykłym zdaniem: „zapisz handoff", „wznów temat follow-upów", „save the session". Skill łapie oba języki.

**Kiedy zapisywać:** przy 50-60% zużycia kontekstu, przy domykaniu wątku albo przed zmianą tematu. Nie przy 90%, kiedy model już stępiał, i nie w połowie działającej implementacji.

Po `/pickup` dostajesz listę plików tematu jako klikalne linki, a potem trzy linie: gdzie jesteśmy, następny krok, czego unikać. Sesja czeka na twoje potwierdzenie, zanim ruszy dalej.

## Format pliku tematu

```markdown
---
kind: handoff-topic
topic: elevenlabs
status: in-progress
updated: 2026-08-12
---

# Głosówki AI generowane przez ElevenLabs

> Zakres: TTS, klony IVC/PVC, koszt per głosówka.
> NIE obejmuje: głosówek nagrywanych ręcznie (→ glosowki-reczne.md)

## Aktualny stan
- ✅ integracja API działa na produkcji
- 🔄 dobór głosu pod polski akcent
- ⛔ klon PVC czeka na 30 min nagrań od klienta

## Kluczowe decyzje i ustalenia
- IVC zamiast PVC na start, bo PVC wymaga 30 min materiału, a IVC 1 min

## Następny krok
Porównać dwa głosy na tych samych 5 zdaniach i wybrać jeden.

## Czego NIE robić
Nie wracać do syntezy lokalnej. Sprawdzone, jakość nie do przyjęcia.

## Artefakty
- `docs/analiza-glosowek.md` — porównanie 4 dostawców i cen
- gałąź `feat/voice-tts`, commit `a1b2c3d`

## Dziennik sesji
- 2026-08-12 — podpięte API, pierwsze 3 głosówki na produkcji
- 2026-08-07 — research dostawców, wybór ElevenLabs
```

Plik ma się mieścić w około 150 liniach. Kiedy puchnie, sesja kondensuje najstarsze wpisy i szczegóły, które przestały być potrzebne.

Gotowe przykłady: [examples/INDEX.md](examples/INDEX.md) i [examples/elevenlabs.md](examples/elevenlabs.md).

## Zasady, które trzymają to w ryzach

**Najpierw indeks.** W obu trybach pierwszą czynnością jest przeczytanie `HANDOFF/INDEX.md`. To on mówi, jakie tematy istnieją i czym się różnią.

**Im mniej plików, tym lepiej.** Sesja szuka pasującego tematu, zanim założy nowy. Sądzi po mechanizmie pracy, nie po nazwie sesji: „poprawa głosówek Roberta" trafia do tematu `elevenlabs`, choć nikt nie wymówił słowa ElevenLabs.

**Wiedza się kumuluje, nie nadpisuje.** Sesja czyta plik w całości i edytuje przyrostowo. Stare, wciąż obowiązujące ustalenia zostają.

**Handoff to stan zadania, nie fakty trwałe.** Kiedy w sesji padnie preferencja albo decyzja projektowa na stałe, skill zaproponuje zapis do pamięci projektu zamiast do handoffu.

## Do czego to pasuje

Do każdego projektu, w którym pracujesz dłużej niż jedną sesję: kod, research, treści, dokumentacja. Folder `HANDOFF/` commituj razem z projektem, wtedy widzi go każda twoja maszyna i każdy współpracownik.

## Co dokładnie instalujesz

```
skills/session-handoff/SKILL.md   # cała logika: struktura, dobór tematu, tryby SAVE i RESUME
commands/handoff.md               # /handoff
commands/pickup.md                # /pickup
```

Trzy pliki markdown, zero zależności, zero kodu wykonywalnego.

## FAQ

**Czym to się różni od `CLAUDE.md`?**
`CLAUDE.md` trzyma reguły, które obowiązują zawsze i ładują się do każdej sesji. Handoff trzyma stan konkretnego wątku pracy i ładuje się tylko wtedy, gdy ten wątek podnosisz.

**Czym to się różni od `/compact`?**
`/compact` ratuje jedną sesję przed przepełnieniem kontekstu. Handoff przenosi wiedzę między sesjami i kumuluje ją w czasie.

**Mam stare handoffy per sesja w `session-logs/`.**
Skill je wciągnie. Przy pierwszym `/handoff` w danym temacie przenosi esencję starego pliku do pliku tematu i dalej pracuje już tylko na `HANDOFF/`.

**Skill jest po polsku, a ja pracuję po angielsku.**
Instrukcje dla modelu są po polsku, ale Claude wykonuje je niezależnie od języka, w którym rozmawiacie. Pliki tematów powstają w twoim języku.

## Licencja

MIT. Rób z tym, co chcesz.
