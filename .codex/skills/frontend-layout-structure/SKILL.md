---
name: frontend-layout-structure
description: Use when improving or reviewing Rails storefront page architecture, especially to keep structure in ERB partials and layouts, flow in controllers, and lightweight behavior in Stimulus/Turbo only.
---

# Frontend Layout Structure

Use this skill when a Rails page layout is drifting across views, helpers, JavaScript, and data models.

## Goal
- Keep ERB, layouts, and partials responsible for page structure.
- Keep CSS and Tailwind responsible for layout primitives and reusable visual rules.
- Keep controllers responsible for route flow and query params.
- Keep Stimulus and Turbo responsible for small interactions only.

## Workflow
1. Identify the Rails route and controller action that own the screen.
2. Move stable sections into ERB templates or partials first.
3. Keep shared chrome in the layout and shared partials, not duplicated per page.
4. Let models store content data only; do not encode page composition in records.
5. Add Stimulus only after the page reads correctly as server-rendered HTML.

## Constraints
- Do not let JS become the source of truth for a fixed Rails route.
- Do not move preview-backed layout decisions into seeds or helpers unless the content is genuinely data-driven.
- Prefer partials over helper-generated HTML.
- Prefer `data-*` hooks over brittle selector chains.

## Checklist
- Does the page read correctly from ERB before Stimulus runs?
- Is the primary hierarchy visible in the route view and shared partials?
- Are layout responsibilities clearly split between layout, page template, partials, and controller?
- Is Turbo or Stimulus enhancing existing markup instead of constructing the page?
- Is repeated rendering limited to records and partial collections?

## Acceptance
- The page shell is understandable by reading the Rails view files alone.
- Layout responsibilities are not split ambiguously across views, helpers, and JS.
- Shared partials cover repeated storefront sections instead of duplicating markup.
