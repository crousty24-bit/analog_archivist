# Analog Archivist

[![Rails](https://img.shields.io/badge/Rails-8.0-red?logo=rubyonrails&logoColor=white)](https://rubyonrails.org/)
[![Ruby](https://img.shields.io/badge/Ruby-3.4-red?logo=ruby&logoColor=white)](https://www.ruby-lang.org/)
[![SQLite](https://img.shields.io/badge/SQLite-3-blue?logo=sqlite&logoColor=white)](https://www.sqlite.org/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-4-06B6D4?logo=tailwindcss&logoColor=white)](https://tailwindcss.com/)
[![Devise](https://img.shields.io/badge/Auth-Devise-6C4AB6)](https://github.com/heartcombo/devise)
[![Project](https://img.shields.io/badge/Project-Codex_Test-111827)](#)

Analog Archivist est un storefront Rails expérimental construit comme projet test Codex.

## Overview

Le projet reproduit un storefront éditorial e-commerce en Rails avec rendu server-side, catalogue, fiche produit, panier, shipping ledger et authentification Devise.

## Initial Approach

La démarche initiale a été la suivante :

1. conception d'une maquette design sur Stitch
2. export d'une `preview.html` servant de modèle visuel
3. initialisation d'un projet Rails avec Codex en se basant sur cette preview

La preview de référence est conservée dans `docs/design-reference/`.

## Stack

- Rails 8
- Ruby 3.4
- SQLite
- Importmap + Turbo + Stimulus
- Tailwind CSS
- Devise

## Application Scope

- Home storefront
- Catalogue produit
- Product show page
- Shipping ledger / cart summary
- Authentification utilisateur avec Devise
- Données de démonstration seedées depuis le projet
- Mode clair / sombre

## Getting Started

### Prerequisites

- Ruby 3.4+
- Bundler
- SQLite 3

### Setup

```bash
bundle install
bin/rails db:prepare
bin/rails db:seed
```

### Run Locally

```bash
bin/dev
```

Le serveur Rails démarre via `Procfile.dev` avec le watcher Tailwind.

## Useful Commands

```bash
bin/rails test
bin/rails tailwindcss:build
bin/rails db:seed
```

## Main Routes

- `/`
- `/catalog`
- `/catalog/:slug`
- `/shipping_ledger`
- `/users/sign_in`

## Notes

- Base de données locale : `storage/development.sqlite3`
- Base de test : `storage/test.sqlite3`
- Le projet est volontairement orienté démonstration/prototypage, pas production-ready

## License

Projet de test Codex. Licence non définie.
