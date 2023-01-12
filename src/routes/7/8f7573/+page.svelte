<script>
    import Puzzle from "$lib/Puzzle.svelte";
    import spongebobImage from "$lib/assets/7/spongebob.png";
</script>

<Puzzle puzzleNumber="7">
    <img src={spongebobImage} />
    <p class="hidden">The password starts with the number 9</p>
</Puzzle>