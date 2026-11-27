<script lang="ts">
	import { onMount } from 'svelte';
	import partyImage from '#lib/assets/9/party.png';
	import cakeImage from '#lib/assets/9/cookies-and-cream-cake.jpeg';

	type Slide = string | { src: string; alt: string };

	const script: Slide[] = [
		'Happy birthdayyyy toooo youuuu',
		'Happy birthdayyyyyy toooooooo youuuuuu',
		'Happy birthdayyyyyy dearrrr Thomasssssss',
		'Happy birthdayyyyyy toooooooo youuuuuuuuuuu',
		{ src: partyImage, alt: 'Party' },
		'Yay you finished!',
		'Congrats!',
		'Here, have some gluten-free cake!',
		{ src: cakeImage, alt: 'Cookies and cream cake' },
		'I hope you enjoyed my little puzzle adventure thingy',
		'And I hope you struggled at least a little bit',
		'And maybe you even learned something new',
		"But knowing you, you'll have solved it incredibly quickly",
		'Even though I expected it to take you several days',
		'But text me and let me know that you finished it',
		'And let me know your thoughts on the puzzles',
		'Because I have been dying to show you them',
		"Anyways, it's your birthday",
		'Which means you should go do birthday things',
		'So I hope you have a happy birthday!',
		'And an amazing day!'
	];

	let slide: Slide | undefined = $state();

	onMount(() => {
		let i = 0;
		const interval = setInterval(() => {
			if (i >= script.length) {
				clearInterval(interval);
				window.location.href = 'https://bucketlistjourney.net/things-to-do-on-your-birthday/';
				return;
			}

			slide = script[i++];
		}, 1750);
		return () => clearInterval(interval);
	});
</script>

<div>
	{#if typeof slide === 'string'}
		<h1>{slide}</h1>
	{:else if slide}
		<img src={slide.src} alt={slide.alt} />
	{/if}
</div>

<style>
	div {
		width: 100vw;
		height: 100vh;
		text-align: center;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	img {
		height: 50vh;
	}
</style>
