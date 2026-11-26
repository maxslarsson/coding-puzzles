<script lang="ts">
	import type { Snippet } from 'svelte';
	import Header from '#lib/Header.svelte';
	import Navigator from '#lib/Navigator.svelte';

	let {
		puzzleNumber,
		showNavigator = true,
		children
	}: { puzzleNumber: number; showNavigator?: boolean; children: Snippet } = $props();
</script>

<section>
	<Header {puzzleNumber} />
	{@render children()}
	{#if showNavigator}
		<Navigator {puzzleNumber} />
	{/if}
</section>
