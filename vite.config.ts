import { svelte } from '@sveltejs/vite-plugin-svelte';
import { globSync } from 'node:fs';
import { resolve } from 'node:path';
import { defineConfig } from 'vite';

const root = resolve('src/pages');

export default defineConfig({
	root,
	appType: 'mpa',
	publicDir: '../../static',
	plugins: [svelte()],
	build: {
		outDir: '../../build',
		emptyOutDir: true,
		// Puzzles 2, 4 and 5 are solved by reading their code in devtools
		minify: false,
		rolldownOptions: {
			// Each page is its own entry rather than a client-side route, so a page's bundle holds only
			// its own puzzle (a router's route manifest would leak every password)
			input: globSync('**/*.html', { cwd: root }).map((page) => resolve(root, page)),
			// Puzzle 5 is solved by injecting into a direct eval, so it has to stay direct
			checks: { eval: false }
		}
	}
});
