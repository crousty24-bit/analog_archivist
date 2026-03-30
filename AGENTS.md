# The Analog Archivist Rails Rules

## Project Scope
- This project is a Rails 8 MVC application.
- The storefront is server-rendered and backed by Active Record models, not by static HTML pages.
- `docs/design-reference/preview_ecommerce.html` is the canonical visual and content source for V1.
- `docs/analog-archivist-global-mockup.html` may help with decomposition, but it must not override the preview design.

## Ownership Rules
- `config/routes.rb` owns URL structure and resource boundaries.
- Controllers own request flow, query params, redirects, and authentication gates.
- Models own persisted catalog, cart, order, newsletter, and Devise-backed user data.
- `app/views/layouts` and shared partials own page structure and repeated UI sections.
- `app/assets/tailwind/application.css` and `app/assets/stylesheets/application.css` own theme tokens, shared styling, and small custom rules.
- Stimulus and Turbo own progressive enhancement only. They must not become the source of truth for page composition.
- `db/seeds.rb` owns preview-derived catalog content and remote asset metadata.

## Rails Conventions
- Keep controllers thin and move reusable domain rules into models or helpers when they are presentation-specific.
- Prefer standard Rails naming, RESTful routes, and partial composition over custom abstractions.
- Do not introduce a CMS, generic page builder, or JSON content layer for V1.
- Use Devise for authentication flows and keep checkout gating at order finalization only.

## Design Structuring Process
1. Start from the preview screen and map it to a Rails route.
2. Move shared chrome into the layout and partials first.
3. Keep fixed editorial structure in ERB templates, not in JavaScript.
4. Store only actual catalog data in the database; keep static layout copy in views and helpers.
5. Verify mobile and desktop composition before adding micro-interactions.

## Frontend Constraints
- Do not invent new pages, sections, or product copy beyond what the preview explicitly supports.
- Preserve the preview’s editorial, tactile, warm, archival tone across public pages and Devise screens.
- Keep JavaScript limited to lightweight behavior such as live totals and Turbo form flows.
- Favor predictable selectors and small Stimulus controllers over ad hoc DOM manipulation.

## Responsive Rules
- Design mobile first, then refine 768px, 1024px, and 1440px layouts.
- Avoid hard minimum widths that break narrow screens.
- Sticky side rails are opt-in and only valid where they improve reading flow.
- Product cards, galleries, and checkout panels must keep intentional ratios and spacing across breakpoints.

## Quality Bar
- No broken navigation between home, catalog, product, shipping ledger, and Devise pages.
- Guest cart flow must work without login.
- Final order creation must require authentication and must empty the cart on success.
- No major overflow on 375px wide screens.
- Tests must cover core model rules and main storefront flows.
