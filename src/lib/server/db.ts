import postgres from 'postgres';
import { env } from '$env/dynamic/private';

if (!env.DATABASE_URL) throw new Error('DATABASE_URL is not set');

const sql = postgres(env.DATABASE_URL);

export default sql;

export interface Submission {
	id: number;
	name: string;
	email: string;
	data: Record<string, unknown>;
	created_at: Date;
}
