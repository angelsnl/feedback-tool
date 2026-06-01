import { describe, it, expect } from 'vitest';
import { validateNoteContent } from './notes';

describe('validateNoteContent', () => {
	it('returns trimmed content for valid input', () => {
		expect(validateNoteContent('  hello  ')).toBe('hello');
	});

	it('returns null for empty string', () => {
		expect(validateNoteContent('')).toBeNull();
	});

	it('returns null for whitespace-only string', () => {
		expect(validateNoteContent('   ')).toBeNull();
	});

	it('returns null for null', () => {
		expect(validateNoteContent(null)).toBeNull();
	});
});
