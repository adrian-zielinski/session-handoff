---
name: session-handoff
description: Use when the user wants to save the session's context for later or resume a topic from a previous session — "wrap up the session", "save a handoff", "zapisz handoff", "zrób handoff", "wznów temat", "kontynuuj z poprzedniej sesji", "czysta sesja", "przekaż kontekst", /handoff, /pickup. Works in ANY project (code and content). Triggers - handoff, pickup, wrap session, save session, resume, continue work, zapisz sesję, wznów, podnieś temat.
---

# Session Handoff — pamięć tematyczna projektu

Kontekst między sesjami żyje w folderze **`HANDOFF/`** w rocie projektu: **jeden plik `.md` = jeden temat** (np. `elevenlabs.md`, `followupy.md`, `prompty.md`, `mvp.md`), plus **`INDEX.md`** — spis wszystkich tematów z opisami. Sesja pod koniec pracy dopisuje swój wkład do pliku WŁAŚCIWEGO TEMATU (nie do pliku per-sesja), a nowa sesja czyta tylko indeks + jeden plik tematu i ma skompresowany kontekst wielu poprzednich sesji naraz. Cel: móc zamknąć sesję nawet w połowie zadania i jutro (albo za tydzień) kontynuować z pełnym rozbiegiem — plik tematu ma dawać przyszłej sesji najlepszy możliwy start.

Dlaczego tak, a nie auto-`/compact`: kompaktowanie odpala się przy PEŁNYM kontekście (model już przytępiony) i robi „streszczenie streszczeń". Handoff piszesz świadomie, wcześniej, a plik tematu kumuluje wiedzę z wielu sesji w jednym miejscu.

## Żelazna reguła: najpierw INDEX.md

**W OBU trybach pierwszą czynnością jest przeczytanie `HANDOFF/INDEX.md`** (jeśli nie istnieje — utwórz folder i indeks). Bez indeksu nie wolno ani zapisywać, ani wznawiać: to on mówi, które tematy istnieją i czym się różnią.

## Struktura

```
HANDOFF/
  INDEX.md        # spis tematów — zawsze czytany pierwszy
  elevenlabs.md   # jeden temat = jeden plik (slug kebab-case, krótki)
  followupy.md
  ...
```

`INDEX.md` — jedna linia na temat, z opisem CO obejmuje i (gdy grozi pomyłka) czego NIE obejmuje:

```markdown
# HANDOFF — indeks tematów

- **[elevenlabs.md](elevenlabs.md)** *(in-progress, akt. 2026-07-13)* — głosówki AI generowane przez ElevenLabs (TTS, klony IVC/PVC). NIE dotyczy głosówek nagrywanych ręcznie przez człowieka → osobny temat.
- **[followupy.md](followupy.md)** *(done, akt. 2026-06-30)* — niezawodność follow-upów: JIT scheduler, send-gate, dead-letter.
```

## Dobór tematu (SAVE) — im mniej plików, tym lepiej

1. Przeczytaj INDEX.md i spróbuj dopasować sesję do ISTNIEJĄCEGO tematu. Nowy plik twórz tylko, gdy żaden opis nie pasuje.
2. **Sądź po mechanizmie, nie po nazwie sesji.** „Poprawa głosówek Roberta" → jeśli chodzi o generowanie głosu, to temat `elevenlabs`, choć nikt nie powiedział „ElevenLabs". Ale głosówki nagrywane ręcznie i wklejane jako plik → to INNY temat.
3. Gdy user podał temat w argumencie — jego wskazanie wygrywa. Gdy dopasowanie jest naprawdę niejednoznaczne — zapytaj (dwie opcje), nie zgaduj.
4. Sesja dotykała dwóch tematów naraz → rozdziel wkład na dwa pliki; nie twórz tematu-zlepka.
5. Po zapisie ZAWSZE zaktualizuj linię tematu w INDEX.md (status, data, opis jeśli zakres się poszerzył — dopisz też „NIE dotyczy…", gdy pojawiło się ryzyko pomyłki z innym tematem).

## Format pliku tematu

Plik tematu to **żywy dokument, nie log**. Przy zapisie AKTUALIZUJESZ sekcje (scal nowy stan, usuń nieaktualne), a do dziennika dodajesz jedną linię.

```markdown
---
kind: handoff-topic
topic: <slug>
status: in-progress | done | blocked
updated: YYYY-MM-DD
---

# <Temat: jedno zdanie o co chodzi>

> Zakres: co obejmuje. NIE obejmuje: ... (→ inny-temat.md)

## Aktualny stan
- ✅ zrobione / 🔄 w toku / ⛔ zablokowane, czeka na...

## Kluczowe decyzje i ustalenia
- decyzja + **dlaczego** (to know-how; stare, wciąż ważne decyzje ZOSTAJĄ)

## Następny krok
Jeden konkretny ruch od którego zacząć następną sesję.

## Czego NIE robić
Ślepe uliczki i odrzucone podejścia — żeby kolejna sesja tam nie wracała.

## Artefakty
Ścieżki WSZYSTKICH plików powstałych/zmienionych w sesjach tematu (researche .md, raporty, plany, kod), plus gałęzie, commity, linki. Przy plikach-dokumentach dopisz w 2-4 słowach, co zawierają.

## Dziennik sesji
- YYYY-MM-DD — jedno-dwa zdania co ta sesja wniosła (najnowsze na górze)
```

Zasada kompresji: plik ma się mieścić w ~150 linii. Gdy puchnie — skondensuj najstarsze wpisy i szczegóły, które przestały być potrzebne; decyzje z „dlaczego" trzymaj najdłużej.

## Tryb SAVE (`/handoff [temat]`)

1. Przeczytaj `HANDOFF/INDEX.md` (utwórz, jeśli brak).
2. Dobierz plik tematu (reguły wyżej). Brak pasującego → nowy plik wg formatu.
3. **Istniejący plik tematu najpierw przeczytaj W CAŁOŚCI, potem edytuj przyrostowo** (narzędziem Edit, nie przepisuj od zera): dopisz nowe ustalenia, zaktualizuj stan, USUŃ to, co się zdezaktualizowało (zamknięte blokady, nieaktualne stany); stary „następny krok", który wciąż obowiązuje, ale przestał być najbliższym ruchem, zdegraduj do dalszej kolejności zamiast kasować. Wiedza z poprzednich sesji, która wciąż obowiązuje, ZOSTAJE — plik jest kumulacją wielu sesji, nie zapisem ostatniej. Dopisz linię dziennika, podbij `updated`/`status`.
4. Zaktualizuj linię w INDEX.md.
5. Jeśli w sesji padł **fakt trwały** (nie stan zadania — preferencja, decyzja projektowa) → zaproponuj zapis do pamięci trwałej projektu, nie do handoffu.
6. Projekt jest w gicie → zacommituj `HANDOFF/` (inne sesje/maszyny muszą to widzieć).

Kiedy zapisywać: przy ~50-60% zużycia kontekstu, przy domykaniu wątku, przed zmianą tematu — nie przy 90%, gdy model już stępiał. Nie przerywaj działającej implementacji w pół kroku, żeby zapisać.

## Tryb RESUME (`/pickup [temat]`)

1. Przeczytaj `HANDOFF/INDEX.md`.
2. User podał temat → dopasuj po opisach z indeksu (osąd, nie tylko literalne dopasowanie slugów). Nie podał → pokaż listę tematów ze statusami i zapytaj, który podnieść.
3. Przeczytaj TYLKO wybrany plik tematu. Nie ładuj innych plików ani historii starych sesji, dopóki nie będą realnie potrzebne.
4. Zweryfikuj lekko rzeczywistość: `git status`/`git log --oneline -5` (kod) albo `ls` folderu roboczego (treść) — czy plik nie odjechał od stanu faktycznego.
5. Odpowiedź zacznij od listy **📂 Pliki tematu** — wszystkie ścieżki z sekcji Artefakty jako klikalne linki markdown (ścieżka względna do roota projektu), każdy z krótkim opisem; ścieżki, które już nie istnieją, oznacz. Potem podsumuj w ~3 liniach: **gdzie jesteśmy → następny krok → czego unikać** i czekaj na potwierdzenie.

## Migracja ze starego systemu

Stare handoffy per-sesja (`session-logs/YYYY-MM-DD-*.md`, frontmatter `kind: handoff`) to archiwum. Gdy przy SAVE temat pokrywa się ze starym plikiem z `session-logs/` — wciągnij jego esencję do pliku tematu (dziennik: data starej sesji) i dalej pracuj już tylko na `HANDOFF/`.
