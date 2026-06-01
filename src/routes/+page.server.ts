import { db } from '$lib/server/db';
import { notes } from '$lib/server/db/schema';
import { validateNoteContent } from '$lib/notes';
import { desc, eq } from 'drizzle-orm';
import { fail } from '@sveltejs/kit';
import type { Actions, PageServerLoad } from './$types';

export const load: PageServerLoad = async () => {
	return {
		notes: await db.select().from(notes).orderBy(desc(notes.createdAt))
	};
};

export const actions: Actions = {
	create: async ({ request }) => {
		const data = await request.formData();
		const content = validateNoteContent(data.get('content'));

		if (!content) return fail(400, { error: 'Note cannot be empty' });

		await db.insert(notes).values({ content });
	},

	delete: async ({ request }) => {
		const data = await request.formData();
		const id = Number(data.get('id'));

		if (!id) return fail(400, { error: 'Invalid id' });

		await db.delete(notes).where(eq(notes.id, id));
	}
};
