<script>
    import Header from "$lib/Header.svelte";
    import Navigator from "$lib/Navigator.svelte";

    export let puzzleNumber;
</script>

<section>
    <Header puzzleNumber={puzzleNumber} />
    <slot />
    <Navigator puzzleNumber={puzzleNumber} />
</section>

<style lang="scss">
</style>