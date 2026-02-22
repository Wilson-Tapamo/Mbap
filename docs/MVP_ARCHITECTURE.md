# Architecture MVP (Next.js + NestJS + PostgreSQL)

## Frontend (Next.js PWA)
- Mobile-first, App Router.
- State local + cache offline (IndexedDB).
- UI: Tailwind + design tokens.
- Modules: Dashboard, POS, Stock, Dépenses, Crédits, Coach IA, Paramètres.

## Backend (NestJS)
- API REST + WebSocket léger pour sync état caisse.
- Services: ventes, inventaire, finance, assistant IA, notifications WhatsApp.
- Auth: JWT + rôles (owner, manager, caissier).

## Data
- PostgreSQL central.
- Queue sync offline -> online.
- Journal d'événements pour audit (cash anomalies).

## IA business invisible
- Entrées: ventes, stocks, marges, dépenses, crédits.
- Sorties:
  - résumé quotidien simple,
  - détection anomalies caisse,
  - prédiction rupture (7 jours),
  - actions recommandées (priorisées).

## Offline-first
- Opérations critiques disponibles hors connexion:
  - vente,
  - dépense,
  - inventaire rapide,
  - transfert stock.
- Politique de résolution conflit: last-write + validation métier.
