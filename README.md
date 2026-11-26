# Coding Puzzles

🧩 A series of coding puzzles modeled after CTFs and similar puzzles

## Developing

Enter the dev shell with `nix develop` (or let direnv do it via `use flake`), then:

```bash
pnpm install
pnpm dev
```

## Building

```bash
pnpm build
```

Each page is its own Vite entry (`src/pages/<n>/<password>.html` with its component beside it), so a page only loads its own puzzle's code.

A wrong password is just a missing page, which GitHub Pages answers with `404.html`. Locally, Vite shows a plain 404 instead; the error page itself is at `/coding-puzzles/404`.

> You can preview the built app with `pnpm preview`. This should _not_ be used to serve your app in production.
