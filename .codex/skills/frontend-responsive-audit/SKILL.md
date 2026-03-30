---
name: frontend-responsive-audit
description: Use when auditing or improving responsive behavior on Rails server-rendered storefront pages, especially for layout density, image ratios, sticky elements, filter panels, and overflow risks across mobile, tablet, and desktop.
---

# Frontend Responsive Audit

Use this skill when a Rails storefront route feels correct on one breakpoint but unstable across others.

## Breakpoints To Check
- 375px: narrow phone
- 768px: tablet portrait
- 1024px: small desktop
- 1440px: wide desktop

## Audit Order
1. Check reading order on mobile.
2. Check horizontal overflow.
3. Check panel stacking and control density.
4. Check image ratios and cropping consistency.
5. Check whether sticky behavior helps or harms.
6. Check card rhythm and CTA alignment in multi-column grids.
7. Check that Turbo and Devise states do not break spacing or page flow.

## Responsive Rules
- Avoid fixed minimum widths unless the page has an alternate narrow layout.
- Filters and toolbars should stack before they compress.
- Titles can grow, but cards must keep a stable baseline alignment.
- Sticky rails should activate only when enough horizontal space exists.
- Gallery thumbnails should degrade gracefully when fewer assets exist.
- Auth forms and checkout forms should reuse the same spacing system as the storefront panels.

## Checklist
- No clipped controls on mobile.
- No overcrowded hero + toolbar combinations on tablet.
- No visually broken card heights in the catalog grid.
- No product rail that becomes too tall or too sticky on intermediate widths.
- No image container that changes role without a compatible ratio.
- No Devise or checkout form that overflows because labels, validation messages, or buttons were not tested responsively.

## Acceptance
- The page remains readable and intentional at all target widths.
- Mobile flow feels designed, not merely compressed.
- Desktop uses extra space to increase clarity, not just spread components apart.
