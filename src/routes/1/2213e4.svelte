<script>
    import Puzzle from "$lib/Puzzle.svelte";
    import {goto} from "$app/navigation";

    let username, password;

    function login() {
        console.log(`Logging in with username "${username}" and password "${password}"`)

        if (username === "admin" && password.toLowerCase() === "4b32b2") {
            goto(`/2/${password.toLowerCase()}`)
        } else {
            console.log("Incorrect username or password")
        }
    }
</script>

<Puzzle puzzleNumber="1" showNavigator=false>
    <div>
        <input placeholder="Username" bind:value={username} />
        <input placeholder="Password" bind:value={password} />
        <button on:click={login}>Login</button>
    </div>
</Puzzle>

<style lang="scss">
  input {
    width: 75%;
    margin-top: 30px;
  }

  button {
    margin: 30px;
  }

  div {
    width: 50%;
    margin: 0 auto;
    border-radius: 20px;
    border: solid white;
  }
</style>