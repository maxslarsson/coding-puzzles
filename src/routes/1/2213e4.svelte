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
        <form on:submit|preventDefault={login}>
            <input placeholder="Username" id="maxslarsson_username_puzzle_1" bind:value={username} />
            <input placeholder="Password" id="maxslarsson_password_puzzle_1" bind:value={password} />
            <button type="submit">Login</button>
        </form>
    </div>
</Puzzle>

<style lang="scss">
  form {
    margin: 0;
  }

  input {
    width: 75%;
    margin-top: 30px;
    margin-left: 30px;
    margin-right: 30px;
  }

  button {
    margin: 30px 50px;
  }

  div {
    width: 50%;
    margin: 0 auto;
    padding: 0px 60px;
    border-radius: 20px;
    border: solid white;
  }
</style>