# Coding Puzzles

🧩 A series of coding puzzles modeled after CTFs and similar puzzles

I made this in January 2022, when I was really into CTFs, as a birthday present for a friend: a chain of nine puzzles, each one's solution unlocking the next.

It's served from the `/coding-puzzles` subpath: [maxslarsson.github.io/coding-puzzles](https://maxslarsson.github.io/coding-puzzles/). `pnpm dev` and `pnpm preview` use the same subpath.

## Developing

Enter the dev shell with `nix develop` (or let direnv do it via `use flake`), then:

```bash
pnpm install
pnpm dev
```

After editing anything in `puzzles/`, regenerate the committed puzzle assets with `nix run .#generate-puzzle-assets`.

## Building

```bash
pnpm build
pnpm check:isolation
```

Each page is its own Vite entry (`src/pages/<n>/<password>.html` with its component beside it), so a page only loads its own puzzle's code. `pnpm check:isolation` checks built asset references, password mentions, source maps, and unexpected public files. Puzzle downloads include their own page's password in the filename, so they cannot be found just by guessing a puzzle number and a generic filename. Encoded puzzle content and computed URLs still need manual review.

A wrong password is just a missing page, which GitHub Pages answers with `404.html`. Locally, Vite shows a plain 404 instead; the error page itself is at `/coding-puzzles/404`.

> You can preview the built app with `pnpm preview`. This should _not_ be used to serve your app in production.
