// Regression guard for this static build, not a proof against arbitrary encoded/computed URLs.
import { readdirSync, readFileSync } from 'node:fs';
import { basename, join, relative } from 'node:path';

const build = process.argv[2] ?? 'build';
const segments = [
	'2213e4',
	'4b32b2',
	'6ba2bf',
	'56382',
	'143b61',
	'22ba57',
	'8f7573',
	'99d116',
	'26abf7'
];
// The welcome page links to puzzle 1; puzzle 2 is solved by reading its source.
const allowedExtra = { 'index.html': ['2213e4'], '2/4b32b2.html': ['6ba2bf'] };
const files = readdirSync(build, { recursive: true, withFileTypes: true })
	.filter((entry) => entry.isFile())
	.map((entry) => relative(build, join(entry.parentPath, entry.name)));
const contents = new Map(
	files.map((file) => {
		let text = readFileSync(join(build, file), 'latin1');
		// Include inline payloads in the password scan (binary/visual puzzles still need review).
		for (const [, encoding, data] of text.matchAll(/data:[^,\s"'`]*?(;base64)?,([^\s"'`<>]+)/g)) {
			try {
				text +=
					'\n' +
					(encoding ? Buffer.from(data, 'base64').toString('latin1') : decodeURIComponent(data));
			} catch {
				// Non-URI text or a truncated match is still scanned verbatim.
			}
		}
		return [file, text];
	})
);
const mentioned = (file) => segments.filter((segment) => contents.get(file).includes(segment));
const errors = [];

function reachableFrom(page) {
	const seen = new Set([page]);
	// Match emitted filenames regardless of syntax: imports (including dynamic imports),
	// preload arrays, fetches, HTML attributes, CSS url()/@import, and JS template literals.
	// Navigation to another HTML page is a progression boundary, not an asset dependency.
	for (const file of seen) {
		for (const target of files) {
			if (!target.endsWith('.html') && contents.get(file).includes(basename(target))) {
				seen.add(target);
			}
		}
	}
	return seen;
}

// These images have no password in their contents or filenames, but belong to later pages.
const imageOwners = { 'location-': 3, 'spongebob-': 7, 'party-': 9, 'cookies-and-cream-cake-': 9 };
for (const page of files.filter((file) => file.endsWith('.html'))) {
	const level = Number(page.split('/')[0]) || 0;
	const allowed = [...segments.slice(0, level), ...(allowedExtra[page] ?? [])];
	const reachable = reachableFrom(page);
	console.log(`${page} loads ${[...reachable].join(' ')}`);
	for (const file of reachable) {
		for (const segment of new Set([
			...mentioned(file),
			...segments.filter((s) => file.includes(s))
		])) {
			if (!allowed.includes(segment))
				errors.push(`${page} loads ${file}, which reveals ${segment}`);
		}
		for (const [prefix, owner] of Object.entries(imageOwners)) {
			if (basename(file).startsWith(prefix) && owner > level) {
				errors.push(`${page} loads puzzle ${owner}'s image: ${file}`);
			}
		}
	}
}

// Static hosting exposes unreferenced files too. Only public hints/metadata, password-named
// pages/downloads, and hashed assets belong in the deployment. No manifests or source maps.
const publicFiles = new Set(['index.html', '404.html', 'robots.txt', 'favicon.png']);
const downloads = new Set(['4/56382.bytes', '6/22ba57.txt', '8/99d116.wasm']);
const pages = new Set(segments.map((segment, i) => `${i + 1}/${segment}.html`));
for (const file of files) {
	if (
		!publicFiles.has(file) &&
		!downloads.has(file) &&
		!pages.has(file) &&
		!/^assets\/.+-[\w-]{8}\.(js|css|png|jpeg)$/.test(file)
	) {
		errors.push(`Unexpected or guessable public file: ${file}`);
	}
	if (file.endsWith('.map') || /sourceMappingURL|sourcesContent/.test(contents.get(file))) {
		errors.push(`Source map exposed: ${file}`);
	}
	if (mentioned(file).length > 2) errors.push(`${file} lists pages: ${mentioned(file).join(' ')}`);
}
for (const page of ['index.html', '404.html', ...pages]) {
	if (!files.includes(page)) errors.push(`Missing page: ${page}`);
}

if (errors.length) {
	console.error(`\n${errors.join('\n')}`);
	process.exit(1);
}
console.log(`\nPuzzle isolation checks passed (${files.length} files checked)`);
