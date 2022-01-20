<script>
    import { fly } from 'svelte/transition';
    export let refresh;
</script>

{#key refresh}
    <div in:fly={{ delay: 150, duration: 150, y: -20 }} out:fly={{ duration: 150,  y: 20 }}>
        <slot />
    </div>
{/key}