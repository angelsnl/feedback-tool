<script lang="ts">
	import { enhance } from '$app/forms';
	import type { PageData, ActionData } from './$types';

	let { data, form }: { data: PageData; form: ActionData } = $props();
</script>

<main>
	<h1>Contact</h1>

	{#if form && 'success' in form && form.success}
		<p class="success">Message sent!</p>
	{/if}

	<form method="POST" use:enhance>
		<div class="field">
			<label for="name">Name</label>
			<input
				id="name"
				name="name"
				type="text"
				value={form?.values?.name ?? ''}
				required
			/>
			{#if form?.errors?.name}
				<span class="error">{form.errors.name}</span>
			{/if}
		</div>

		<div class="field">
			<label for="email">Email</label>
			<input
				id="email"
				name="email"
				type="email"
				value={form?.values?.email ?? ''}
				required
			/>
			{#if form?.errors?.email}
				<span class="error">{form.errors.email}</span>
			{/if}
		</div>

		<div class="field">
			<label for="message">Message</label>
			<textarea id="message" name="message" required
				>{form?.values?.message ?? ''}</textarea
			>
			{#if form?.errors?.message}
				<span class="error">{form.errors.message}</span>
			{/if}
		</div>

		<button type="submit">Send</button>
	</form>

	{#if data.submissions.length > 0}
		<section>
			<h2>Submissions</h2>
			<ul>
				{#each data.submissions as sub (sub.id)}
					<li>
						<strong>{sub.name}</strong> &lt;{sub.email}&gt;
						<pre>{JSON.stringify(sub.data, null, 2)}</pre>
						<time datetime={String(sub.created_at)}
							>{new Date(sub.created_at).toLocaleString()}</time
						>
					</li>
				{/each}
			</ul>
		</section>
	{/if}
</main>

<style>
	main {
		max-width: 600px;
		margin: 2rem auto;
		padding: 0 1rem;
		font-family: sans-serif;
	}

	.field {
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
		margin-bottom: 1rem;
	}

	label {
		font-weight: 600;
	}

	input,
	textarea {
		padding: 0.5rem;
		border: 1px solid #ccc;
		border-radius: 4px;
		font-size: 1rem;
	}

	textarea {
		min-height: 100px;
		resize: vertical;
	}

	button {
		padding: 0.5rem 1.5rem;
		background: #333;
		color: #fff;
		border: none;
		border-radius: 4px;
		cursor: pointer;
		font-size: 1rem;
	}

	button:hover {
		background: #555;
	}

	.error {
		color: #c00;
		font-size: 0.875rem;
	}

	.success {
		color: #060;
		font-weight: 600;
	}

	section {
		margin-top: 2rem;
	}

	ul {
		list-style: none;
		padding: 0;
	}

	li {
		padding: 0.75rem 0;
		border-bottom: 1px solid #eee;
	}

	pre {
		background: #f5f5f5;
		padding: 0.5rem;
		border-radius: 4px;
		font-size: 0.8rem;
		margin: 0.25rem 0;
		overflow-x: auto;
	}

	time {
		display: block;
		font-size: 0.8rem;
		color: #888;
	}
</style>
