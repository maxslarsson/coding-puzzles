<script>
    import { onMount } from "svelte";

    import { quintOut } from 'svelte/easing';
    import { crossfade } from 'svelte/transition';
    import { flip } from 'svelte/animate';
    import Puzzle from "$lib/Puzzle.svelte";

    let key;

    onMount(async () => {
        const salt = new Uint8Array([1, 2, 3, 4, 5, 6, 10]);
        let enc = new TextEncoder();

        let keyMaterial = await window.crypto.subtle.importKey(
            "raw",
            enc.encode("SuperSecureKey"),
            "PBKDF2",
            false,
            ["deriveBits", "deriveKey"]
        );

        key = await window.crypto.subtle.deriveKey(
            {
                "name": "PBKDF2",
                salt: salt,
                "iterations": 100000,
                "hash": "SHA-256"
            },
            keyMaterial,
            { "name": "AES-GCM", "length": 256},
            true,
            [ "encrypt", "decrypt" ]
        );
    })

    const [send, receive] = crossfade({
        duration: d => Math.sqrt(d * 200),

        fallback(node, params) {
            const style = getComputedStyle(node);
            const transform = style.transform === 'none' ? '' : style.transform;

            return {
                duration: 600,
                easing: quintOut,
                css: t => `
					transform: ${transform} scale(${t});
					opacity: ${t}
				`
            };
        }
    });



    let uid = 1;

    let todos = [
        { id: uid++, done: true, description: 'write source code' },
        { id: uid++, done: true, description: 'fix some bugs' },
        { id: uid++, done: false, description: 'find the password' },
    ];

    async function add(input) {
        console.log("Adding todo!")
        const ciphertext = new Uint8Array([180, 42, 92, 224, 143, 168, 229, 76, 11, 30, 247, 195, 68, 109, 79, 124, 79, 234, 231, 28, 120, 183]);
        const iv = new Uint8Array([98, 249, 255, 129, 32, 147, 153, 83, 181, 46, 9, 151]);

        let password = await window.crypto.subtle.decrypt(
            {
                name: "AES-GCM",
                iv: iv
            },
            key,
            ciphertext
        )
        const decoder = new TextDecoder("utf-8");
        password = decoder.decode(password);

        const todo = {
            id: uid++,
            done: false,
            description: eval(`let password="${password}";"${input.value}"`)
        };

        todos = [todo, ...todos];
        input.value = '';
    }

    function remove(todo) {
        console.log("Removing todo!")
        todos = todos.filter(t => t !== todo);
    }

    function mark(todo, done) {
        todo.done = done;
        remove(todo);
        todos = todos.concat(todo);
    }
</script>

<Puzzle puzzleNumber="5">
    <div class='board'>
        <input
                placeholder="What needs to be done?"
                on:keydown={e => e.key === 'Enter' && add(e.target)}
        >

        <div class='left'>
            <h2>Todo</h2>
            {#each todos.filter(t => !t.done) as todo (todo.id)}
                <div
                        class="card"
                        in:receive="{{key: todo.id}}"
                        animate:flip="{{duration: 200}}"
                >
                    <input type=checkbox on:change={() => mark(todo, true)}>
                    {todo.description}
                    <button on:click="{() => remove(todo)}">remove</button>
                </div>
            {/each}
        </div>

        <div class='right'>
            <h2>Done</h2>
            {#each todos.filter(t => t.done) as todo (todo.id)}
                <div
                        class="card done"
                        in:receive="{{key: todo.id}}"
                >
                    <input type=checkbox checked on:change={() => mark(todo, false)}>
                    {todo.description}
                    <button on:click="{() => remove(todo)}">remove</button>
                </div>
            {/each}
        </div>
    </div>
</Puzzle>

<style>
    .board {
        display: grid;
        grid-template-columns: 1fr 1fr;
        grid-gap: 1em;
        max-width: 36em;
        margin: 0 auto;
    }

    .board > input {
        font-size: 1.4em;
        grid-column: 1/3;
    }

    h2 {
        font-size: 2em;
        font-weight: 200;
        user-select: none;
        margin: 0 0 0.5em 0;
    }

    .card {
        position: relative;
        line-height: 1.2;
        padding: 0.5em 2.5em 0.5em 2em;
        margin: 0 0 0.5em 0;
        user-select: none;
        border: 1px solid hsl(240, 8%, 70%);
        background-color:hsl(240, 8%, 93%);
        color: #333;
        border-radius: 12px;
    }

    input[type="checkbox"] {
        position: absolute;
        left: 0.5em;
        top: 0.8em;
        margin: 0;
    }

    .done {
        border: 1px solid hsl(240, 8%, 90%);
        background-color:hsl(240, 8%, 98%);
    }

    button {
        position: absolute;
        top: 0;
        right: 0.2em;
        width: 2em;
        height: 100%;
        background: no-repeat 50% 50% url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Cpath fill='%23676778' d='M12,2C17.53,2 22,6.47 22,12C22,17.53 17.53,22 12,22C6.47,22 2,17.53 2,12C2,6.47 6.47,2 12,2M17,7H14.5L13.5,6H10.5L9.5,7H7V9H17V7M9,18H15A1,1 0 0,0 16,17V10H8V17A1,1 0 0,0 9,18Z'%3E%3C/path%3E%3C/svg%3E");
        background-size: 1.4em 1.4em;
        border: none;
        opacity: 0;
        transition: opacity 0.2s;
        text-indent: -9999px;
        cursor: pointer;
    }

    .card:hover button {
        opacity: 1;
    }
</style>