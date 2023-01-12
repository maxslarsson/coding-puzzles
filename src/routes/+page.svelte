<script>
  import Link from "$lib/Link.svelte";
  import {base} from "$app/paths";
</script>

<svelte:head>
    <title>Coding Puzzles</title>
</svelte:head>

<section>
    <h1>Welcome!</h1>
    <p>This is a series of difficult (I hope) puzzles that are based off of various CTFs that I have competed in over the years with some newly designed problems. Some problems require unique solutions, or at least they should if I designed them correctly.</p>
    <p>The goal of each puzzle is to find a passcode of length 6 that consists of any combination of numbers 0-9 and letters a-f. Capitalization does not matter for the passcode. Once you find the password, enter it in the form at the bottom of the puzzle page.</p>
    <p>Beware, many of these puzzles are designed to be vague and thus difficult as well. If you are stuck on a problem for a long time, feel free to send me <a href="mailto:c23ml@dalton.org">an email</a> or talk to me in person.</p>
    <p>To begin, go to the <a href="{base}/1/2213e4">first puzzle</a></p>
</section>