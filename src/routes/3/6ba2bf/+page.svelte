<script>
    import Puzzle from "$lib/Puzzle.svelte";
    import locationImage from "$lib/assets/3/location.png"
</script>

<Puzzle puzzleNumber="3">
    <img src={locationImage} width="65%"/>
    <p>To find the passcode, <bold>cut</bold> both the latitude and longitude of where the picture was taken to three decimal places each, add them together, and multiply them by 1,000 to get rid of the decimal point.</p>
</Puzzle>