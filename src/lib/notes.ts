export function validateNoteContent(value: FormDataEntryValue | null): string | null {
	if (!value || typeof value !== 'string' || !value.trim()) return null;
	return value.trim();
}
