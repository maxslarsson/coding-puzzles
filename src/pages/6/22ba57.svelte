<script lang="ts">
	import { onMount } from 'svelte';
	import Puzzle from '#lib/Puzzle.svelte';

	let body = $state('');

	onMount(async () => {
		const res = await fetch(`${import.meta.env.BASE_URL}6/22ba57.txt`);
		body = await res.text();
	});
</script>

<Puzzle puzzleNumber={6}>
	<p>{body}</p>
</Puzzle>
