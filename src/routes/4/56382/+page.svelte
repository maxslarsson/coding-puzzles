<script>
    import Puzzle from "$lib/Puzzle.svelte";
    import { onMount } from 'svelte';
    import {base} from "$app/paths";

    let key = "";
    let pngByteString = "data:image/png;base64,";
    let fetchedBytes = [];

    onMount(async () => {
        const res = await fetch(`${base}/4/bytes`);
        const body = await res.text();
        fetchedBytes = Array.from(body.split(" "), x => parseInt(x));
    });

    function generatePNG() {
        const LEN = 8;

        if (key.length !== LEN)
            return;

        console.log("Generating PNG!");
        console.log(`Key Provided: ${key}`)

        let result = []
        for(let i = 0; i < LEN; i++) {
            let shifter = key.charCodeAt(i);
            for (let j = 0; j < (fetchedBytes.length / LEN); j++) {
                let index = (j * LEN) + i;
                result[index] = fetchedBytes[index] ^ shifter;
            }
        }

        while(result[result.length-1] === 0){
            result = result.slice(0,result.length-1);
        }

        pngByteString = "data:image/png;base64," + btoa(String.fromCharCode.apply(null, new Uint8Array(result)))
        console.log(`<img src="${pngByteString}" />`)
    }
</script>

<Puzzle puzzleNumber="4">
    <p>Uh oh... the PNG seems to be invalid...</p>
    <input placeholder="Enter key" bind:value={key} on:input={generatePNG}>
    <div id="imgHolder">
        <img src={pngByteString} />
    </div>
</Puzzle>

<style>
    #imgHolder {
      width: 400px;
      margin: 0 auto;
      height: 150px;
    }

    #imgHolder img {
        width: 100%;
        height: 100%;
    }

    input {
      margin-bottom: 35px;
    }
</style>