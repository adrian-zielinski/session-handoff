---
kind: handoff-topic
topic: elevenlabs
status: in-progress
updated: 2026-08-12
---

# Głosówki AI generowane przez ElevenLabs

> Ten plik jest przykładem wypełnionego tematu.
> Zakres: TTS, klony IVC/PVC, koszt per głosówka, dobór głosu.
> NIE obejmuje: głosówek nagrywanych ręcznie i wklejanych jako plik (→ glosowki-reczne.md)

## Aktualny stan
- ✅ integracja z API działa na produkcji, flaga włączona dla jednej organizacji
- 🔄 dobór głosu: dwa kandydaty, brakuje odsłuchu na dłuższych zdaniach
- ⛔ klon PVC zablokowany: potrzeba 30 min nagrań, klient przysłał 4 min

## Kluczowe decyzje i ustalenia
- IVC zamiast PVC na start, bo PVC wymaga 30 min materiału, a IVC wystarczy 1 min. Jakość IVC okazała się wystarczająca na testach odbiorczych.
- Koszt liczymy per znak, nie per plik. Przy 400 znakach średniej głosówki wychodzi ~0,12 PLN.
- Cache na poziomie tekstu: te same zdania w openerach generujemy raz i odtwarzamy z bucketu.

## Następny krok
Zestawić dwa kandydujące głosy na tych samych 5 zdaniach i wybrać jeden.

## Czego NIE robić
- Nie wracać do syntezy lokalnej. Sprawdzone w lipcu, jakość nie do przyjęcia przy polskich końcówkach.
- Nie generować głosówek w locie przy wysyłce. Opóźnienie 3-6 s wywalało okno wysyłki.

## Artefakty
- `docs/analiza-glosowek.md` — porównanie 4 dostawców, ceny i próbki
- `src/voice/tts-client.ts` — klient API z retry i cache
- gałąź `feat/voice-tts`, commit `a1b2c3d`
- [panel ElevenLabs](https://elevenlabs.io) — sloty głosów, limit planu

## Dziennik sesji
- 2026-08-12 — podpięte API, pierwsze 3 głosówki poszły na produkcję za flagą
- 2026-08-09 — cache na poziomie tekstu, koszt spadł o połowę
- 2026-08-07 — research dostawców, wybór ElevenLabs, decyzja IVC zamiast PVC
