<script>
    import { onMount } from 'svelte';
    import Puzzle from "$lib/Puzzle.svelte";
    import {base} from "$app/paths";

    let body;
x
    onMount(async () => {
        const res = await fetch(`${base}/6/hexdump.txt`);
        body = await res.text();
    })
</script>

<Puzzle puzzleNumber="6">
    <p>{body}</p>
<!--    <img src="/6/file.png" width="65%" />-->
<!--    TODO: Add the Hint back in-->
<!--    <p class="hidden">Ittttttt's wasm time</p>-->
</Puzzle>