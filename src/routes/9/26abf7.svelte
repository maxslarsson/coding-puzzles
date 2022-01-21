<!--<script context="module">-->
<!--    export async function load() {-->
<!--        return {-->
<!--            status: 302,-->
<!--            redirect: "/login"-->
<!--        };-->
<!--    }-->
<!--</script>-->

<script>
    import {onMount} from "svelte";
    import {goto} from "$app/navigation";

    let script = [
        "Happy birthdayyyy toooo youuuu",
        "Happy birthdayyyyyy toooooooo youuuuuu",
        "Happy birthdayyyyyy dearrrr Thomasssssss",
        "Happy birthdayyyyyy toooooooo youuuuuuuuuuu",
        "/9/party.png",
        "Yay you finished!",
        "Congrats!",
        "Here, have some gluten-free cake!",
        "/9/cookies-and-cream-cake.jpeg",
        "I hope you enjoyed my little puzzle adventure thingy",
        "And I hope you struggled at least a little bit",
        "And maybe you even learned something new",
        "But knowing you, you'll have solved it incredibly quickly",
        "Even though I expected it to take you several days",
        "But text me and let me know that you finished it",
        "And let me know your thoughts on the puzzles",
        "Because I have been dying to show you them",
        "Anyways, it's your birthday",
        "Which means you should go do birthday things",
        "So I hope you have a happy birthday!",
        "And an amazing day!"
    ]

    let delay = 1750;
    let i = 0;
    let showText;
    let contents;

    onMount(() => {
        let interval = setInterval(() => {
            if (i >= script.length) {
                clearInterval(interval);
                goto("https://bucketlistjourney.net/things-to-do-on-your-birthday/");
                return;
            }

            contents = script[i];
            showText = !contents.startsWith("/")
            i++;
        }, delay);
    })
</script>

<svelte:head>
    <title>Congrats!</title>
</svelte:head>

<div>
    {#if showText}
        <h1>{contents}</h1>
    {:else}
        <img src={contents} />
    {/if}
</div>

<style lang="scss">
    div {
      width: 100vw;
      height: 100vh;
      text-align: center;
      display:flex;
      align-items: center;
      justify-content: center;
    }

    img {
      height: 50vh;
    }
</style>
