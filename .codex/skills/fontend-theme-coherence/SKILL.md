---
name: frontend-theme-coherence
description: Use when refining or reviewing the visual consistency of the Rails storefront theme, especially to keep typography, palette, surfaces, cards, CTAs, badges, imagery, and decorative texture aligned across views and Devise screens.
---

# Frontend Theme Coherence

Use this skill when the preview-derived theme exists but feels uneven across Rails views or auth screens.

## Theme Intent
- Editorial, tactile, archival
- Warm surfaces and restrained contrast
- Serif-led hierarchy with clean sans-serif support
- Decorative texture used sparingly, never as noise for its own sake

## Visual Rules
- Headlines should feel curated and literary, not generic storefront.
- Surfaces should form a small, repeatable system: base canvas, raised panel, soft inset panel.
- Badges, chips, and CTA styles should come from the same tone family.
- Cards should share the same visual grammar even when content changes.
- Decorative texture and gradients should support atmosphere, not reduce readability.
- Devise pages should reuse the same material language as the shipping ledger and newsletter sections.

## Asset Rules
- Product imagery should feel consistent in framing within each role.
- Card images, hero images, and secondary gallery images must each have a defined visual purpose.
- Fallback assets must preserve theme coherence, not just fill empty space.
- Tailwind tokens and custom CSS should express the theme once and be reused by every view.

## Checklist
- Are headings, meta labels, and body copy clearly hierarchical?
- Do catalog cards and product panels feel like the same system?
- Are badges and chips consistent in casing, weight, and contrast?
- Is the same palette logic used on both catalog and product pages?
- Do asset choices reinforce the same editorial mood?
- Do Devise views feel like part of the same archive rather than a default scaffold?

## Acceptance
- The catalog and product pages feel like adjacent chapters of the same brand.
- There is no isolated component that looks imported from another design system.
- Theme decisions are reusable and legible, not one-off exceptions.
