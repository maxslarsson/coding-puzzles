# Coding Puzzles

🧩 A series of coding puzzles modeled after CTFs and similar puzzles

I made this in January 2022, when I was really into CTFs, as a birthday present for a friend: a chain of nine puzzles, each one's solution unlocking the next.

It's live at [puzzles.maxlarsson.dev](https://puzzles.maxlarsson.dev), served from the domain root as a Cloudflare Worker with static assets (`wrangler.jsonc`).

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
```

Each page is its own Vite entry (`src/pages/<n>/<password>.html` with its component beside it), so a page only loads its own puzzle's code. `pnpm build` then runs `scripts/check-isolation.js`, which fails the build on a leak. It checks built asset references, password mentions, source maps, and unexpected public files. Puzzle downloads include their own page's password in the filename, so they cannot be found just by guessing a puzzle number and a generic filename. Encoded puzzle content and computed URLs still need manual review.

A wrong password is just a missing page, which Cloudflare answers with `404.html` and a 404 status. Vite's `pnpm dev` and `pnpm preview` show a plain 404 instead, so to see the error page like production, build and run `pnpm exec wrangler dev`.

## Deploying

Cloudflare Workers Builds deploys every push to `main` to `puzzles.maxlarsson.dev`, and other branches and PRs get preview URLs. Its build command is `pnpm run build`, which includes the isolation check, so a leaked password blocks the deploy.
