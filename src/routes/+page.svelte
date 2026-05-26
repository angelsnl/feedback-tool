<script lang="ts">
	import { enhance } from '$app/forms';
	import type { PageData, ActionData } from './$types';

	let { data, form }: { data: PageData; form: ActionData } = $props();

	let content = $state('');
	let submitting = $state(false);
</script>

<svelte:head>
	<title>Notes</title>
</svelte:head>

<main>
	<div class="container">
		<h1>Notes</h1>

		<form
			method="POST"
			action="?/create"
			use:enhance={() => {
				submitting = true;
				return async ({ update }) => {
					await update();
					content = '';
					submitting = false;
				};
			}}
		>
			<div class="input-row">
				<textarea
					name="content"
					bind:value={content}
					placeholder="Write a note..."
					rows="3"
					required
				></textarea>
				<button type="submit" disabled={submitting || !content.trim()}>Add</button>
			</div>
			{#if form?.error}
				<p class="error">{form.error}</p>
			{/if}
		</form>

		<ul class="notes">
			{#each data.notes as note (note.id)}
				<li>
					<p>{note.content}</p>
					<div class="meta">
						<time>{new Date(note.createdAt).toLocaleString()}</time>
						<form method="POST" action="?/delete" use:enhance>
							<input type="hidden" name="id" value={note.id} />
							<button type="submit" class="delete" aria-label="Delete note">×</button>
						</form>
					</div>
				</li>
			{:else}
				<li class="empty">No notes yet.</li>
			{/each}
		</ul>
	</div>
</main>

<style>
	:global(*, *::before, *::after) {
		box-sizing: border-box;
		margin: 0;
		padding: 0;
	}

	:global(body) {
		font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
		background: #f7f7f5;
		color: #1a1a1a;
		min-height: 100vh;
	}

	main {
		padding: 2rem 1rem;
	}

	.container {
		max-width: 640px;
		margin: 0 auto;
		display: flex;
		flex-direction: column;
		gap: 2rem;
	}

	h1 {
		font-size: 1.75rem;
		font-weight: 700;
		letter-spacing: -0.02em;
	}

	form {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
	}

	.input-row {
		display: flex;
		gap: 0.75rem;
		align-items: flex-start;
	}

	textarea {
		flex: 1;
		padding: 0.75rem 1rem;
		border: 1.5px solid #e0e0e0;
		border-radius: 8px;
		font-size: 0.95rem;
		font-family: inherit;
		resize: vertical;
		background: #fff;
		transition: border-color 0.15s;
		line-height: 1.5;
	}

	textarea:focus {
		outline: none;
		border-color: #6366f1;
	}

	button[type='submit']:not(.delete) {
		padding: 0.75rem 1.25rem;
		background: #6366f1;
		color: #fff;
		border: none;
		border-radius: 8px;
		font-size: 0.9rem;
		font-weight: 600;
		cursor: pointer;
		white-space: nowrap;
		transition: background 0.15s, opacity 0.15s;
	}

	button[type='submit']:not(.delete):hover {
		background: #4f46e5;
	}

	button[type='submit']:not(.delete):disabled {
		opacity: 0.45;
		cursor: not-allowed;
	}

	.error {
		font-size: 0.875rem;
		color: #dc2626;
	}

	.notes {
		list-style: none;
		display: flex;
		flex-direction: column;
		gap: 0.75rem;
	}

	.notes li {
		background: #fff;
		border: 1.5px solid #e8e8e8;
		border-radius: 10px;
		padding: 1rem 1.25rem;
		display: flex;
		flex-direction: column;
		gap: 0.75rem;
	}

	.notes li p {
		font-size: 0.95rem;
		line-height: 1.6;
		white-space: pre-wrap;
	}

	.meta {
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	time {
		font-size: 0.8rem;
		color: #888;
	}

	.delete {
		background: none;
		border: none;
		color: #bbb;
		font-size: 1.25rem;
		cursor: pointer;
		line-height: 1;
		padding: 0 0.25rem;
		transition: color 0.15s;
	}

	.delete:hover {
		color: #dc2626;
	}

	.empty {
		color: #888;
		font-size: 0.9rem;
		padding: 1rem 0;
		border: none !important;
		background: none !important;
	}
</style>
