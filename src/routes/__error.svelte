<script>
    function goBack() {
        window.history.back()
    }
</script>

<svelte:head>
    <title>Incorrect!</title>
</svelte:head>

<section>
    <h1>Uh oh! That seems to be incorrect!</h1>
    <button on:click={goBack}>
        Go Back
    </button>
</section>

<style lang="scss">
    button {
      padding: 10px 20px;
      background-color: white;
      color: black;
      border-radius: 12px;
      outline: none;
      border: none;
    }
</style>