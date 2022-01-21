<script>
    export let puzzleNumber;

    import { goto } from "$app/navigation";

    let input = "";

    function visitPath() {
        goto(`/${parseInt(puzzleNumber)+1}/${input.toLowerCase()}`)
    }
</script>

<section>
    <form on:submit|preventDefault={visitPath}>
        <input placeholder="Enter password" id={`maxslarsson_password_puzzle_${puzzleNumber}`} bind:value={input}>
        <button type="submit">Submit</button>
    </form>
</section>