import { readdir, readFile } from "fs/promises";
import { join } from "path";
import { fileURLToPath } from "url";
import postgres from "postgres";

const url = process.env.DATABASE_URL;
console.log("url: ", url);
if (!url) throw new Error("DATABASE_URL is not set");

const sql = postgres(url);
const dir = join(fileURLToPath(import.meta.url), "..");

async function migrate() {
  await sql`
		CREATE TABLE IF NOT EXISTS schema_migrations (
			name       TEXT PRIMARY KEY,
			applied_at TIMESTAMPTZ DEFAULT now()
		)
	`;

  const files = (await readdir(dir)).filter((f) => f.endsWith(".sql")).sort();

  for (const file of files) {
    const name = file.slice(0, -4);
    const [row] =
      await sql`SELECT 1 FROM schema_migrations WHERE name = ${name}`;
    if (row) {
      console.log(`skip     ${name}`);
      continue;
    }

    const content = await readFile(join(dir, file), "utf8");
    console.log(`applying ${name}`);
    await sql.begin(async (tx) => {
      await tx.unsafe(content);
      await tx`INSERT INTO schema_migrations (name) VALUES (${name})`;
    });
    console.log(`applied  ${name}`);
  }

  await sql.end();
}

migrate().catch((err) => {
  console.error(err);
  process.exit(1);
});
