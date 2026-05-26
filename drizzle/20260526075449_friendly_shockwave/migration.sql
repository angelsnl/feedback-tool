CREATE TABLE "notes" (
	"id" serial PRIMARY KEY,
	"content" text NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL
);
