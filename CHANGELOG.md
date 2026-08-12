# Changelog

Format: [Keep a Changelog](https://keepachangelog.com/), wersjonowanie [SemVer](https://semver.org/lang/pl/).

## [1.0.0] — 2026-08-12

Pierwsze publiczne wydanie.

### Dodane
- Skill `session-handoff` z trybami SAVE i RESUME.
- Komendy `/handoff` i `/pickup`.
- Instalacja jako plugin Claude Code (`.claude-plugin/`), przez `install.sh` albo ręcznie.
- Przykłady: `examples/INDEX.md` i `examples/elevenlabs.md`.
- README po polsku i po angielsku.

### Model pracy
- Jeden plik `.md` = jeden temat w folderze `HANDOFF/`, plus `INDEX.md` czytany zawsze pierwszy.
- Plik tematu jako żywy dokument: sesja aktualizuje sekcje i usuwa zdezaktualizowane, zamiast dopisywać kolejny log.
- Migracja ze starych handoffów per sesja (`session-logs/`) przy pierwszym zapisie w danym temacie.
