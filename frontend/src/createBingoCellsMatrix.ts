const RANGES = {
	B: [1, 15],
	I: [16, 30],
	N: [31, 45],
	G: [46, 60],
	O: [61, 75],
};

const ALL_CELLS = Object.fromEntries(
	Object.entries(RANGES).map(([letter, [start, end]]) => [
		letter,
		(() => {
			const range = [];
			for (let i = start; i <= end; i++) {
				range.push(String(i));
			}

			return range;
		})(),
	]),
);

function toShuffled<T>(arr: T[]) {
	return [...arr].sort(() => Math.random() - 0.5);
}

function bingo(letter: string) {
	const shuffled = toShuffled(ALL_CELLS[letter]);
	const column = [letter].concat(shuffled.slice(0, 5));

	if (letter === "N") {
		column[3] = "FREE";
	}

	return column;
}
export function createBingoCellsMatrix() {
	return "BINGO".split("").map(bingo);
}
