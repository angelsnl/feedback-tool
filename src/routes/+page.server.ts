import { fail } from '@sveltejs/kit';
import type { Actions, PageServerLoad } from './$types';
import sql from '$lib/server/db';
import type { Submission } from '$lib/server/db';
import getSubmissionsSQL from '$lib/server/queries/get_submissions.sql?raw';
import insertSubmissionSQL from '$lib/server/queries/insert_submission.sql?raw';

export const load: PageServerLoad = async () => {
	const submissions = await sql.unsafe<Submission[]>(getSubmissionsSQL);
	return { submissions };
};

export const actions: Actions = {
	default: async ({ request }) => {
		const formData = await request.formData();
		const name = String(formData.get('name') ?? '').trim();
		const email = String(formData.get('email') ?? '').trim();
		const message = String(formData.get('message') ?? '').trim();

		const errors: Partial<Record<'name' | 'email' | 'message', string>> = {};
		if (!name) errors.name = 'Required';
		if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) errors.email = 'Valid email required';
		if (!message) errors.message = 'Required';

		if (Object.keys(errors).length) {
			return fail(400, { errors, values: { name, email, message } });
		}

		await sql.unsafe(insertSubmissionSQL, [name, email, JSON.stringify({ message })]);

		return { success: true };
	}
};
