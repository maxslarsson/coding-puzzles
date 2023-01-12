<script>
    import Header from "$lib/Header.svelte";
    import Navigator from "$lib/Navigator.svelte";

    export let puzzleNumber;

    // This is a string, because when it is passed as a prop, it is converted to a string. Thus, there is no type error when I compare it to a string.
    export let showNavigator = "true";
</script>

<section>
    <Header puzzleNumber={puzzleNumber} />
    <slot />
    {#if (showNavigator === 'true')}
        <Navigator puzzleNumber={puzzleNumber} />
    {/if}
</section>
