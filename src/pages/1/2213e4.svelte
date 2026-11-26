<script lang="ts">
	import Puzzle from '#lib/Puzzle.svelte';

	let username = $state('');
	let password = $state('');

	function login(event: SubmitEvent) {
		event.preventDefault();
		console.log(`Logging in with username "${username}" and password "${password}"`);

		if (username === 'admin' && password.toLowerCase() === '4b32b2') {
			window.location.href = `${import.meta.env.BASE_URL}2/4b32b2`;
		} else {
			console.log('Incorrect username or password');
		}
	}
</script>

<Puzzle puzzleNumber={1} showNavigator={false}>
	<div>
		<form onsubmit={login}>
			<input placeholder="Username" id="maxslarsson_username_puzzle_1" bind:value={username} />
			<input placeholder="Password" id="maxslarsson_password_puzzle_1" bind:value={password} />
			<button type="submit">Login</button>
		</form>
	</div>
</Puzzle>

<style>
	form {
		margin: 0;
	}

	input {
		width: 75%;
		margin-top: 30px;
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
