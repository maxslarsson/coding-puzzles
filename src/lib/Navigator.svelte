<script lang="ts">
	let { puzzleNumber }: { puzzleNumber: number } = $props();

	let input = $state('');

	function visitPath(event: SubmitEvent) {
		event.preventDefault();
		// A wrong guess is a missing page, so the host serves 404.html
		window.location.href = `${import.meta.env.BASE_URL}${puzzleNumber + 1}/${input.toLowerCase()}`;
	}
</script>

<section>
	<form onsubmit={visitPath}>
		<input
			placeholder="Enter password"
			id={`maxslarsson_password_puzzle_${puzzleNumber}`}
			bind:value={input}
		/>
		<button type="submit">Submit</button>
	</form>
</section>
