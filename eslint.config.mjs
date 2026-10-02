import eslint from "@eslint/js";
import tseslint from "typescript-eslint";

export default [
	{
		ignores: [".next/**", "node_modules/**", "playwright-report/**", "test-results/**"]
	},
	eslint.configs.recommended,
	...tseslint.configs.recommended
];