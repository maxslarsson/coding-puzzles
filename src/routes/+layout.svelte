<script context="module">
  export const load = async ({ url }) => ({
    props: {
      key: url.pathname,
    },
  });
</script>

<script>
  import "../app.css";
  import Transition from "$lib/Transition.svelte";

  export let key;
</script>

<Transition refresh={key}>
    <main>
        <slot />
    </main>
</Transition>
