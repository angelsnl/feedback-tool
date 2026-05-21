INSERT INTO submissions (name, email, data)
VALUES ($1, $2, $3::jsonb);
