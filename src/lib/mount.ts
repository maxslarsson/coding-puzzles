import '../app.css';
import { mount, type Component } from 'svelte';

export default (page: Component) =>
	mount(page, { target: document.body.appendChild(document.createElement('main')) });
