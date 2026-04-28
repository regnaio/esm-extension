# navcat NodeNext module resolution repro

Minimal repro of `navcat@0.3.0` `.d.ts` relative imports failing under
TypeScript with `module: NodeNext` + `moduleResolution: NodeNext`.

## Config

- `package.json` — `"type": "module"`, pins `navcat@0.3.0` + `typescript@6.0.3`
- `tsconfig.json` — `module: NodeNext`, `moduleResolution: NodeNext`, `strict: true`, `verbatimModuleSyntax: true`, `skipLibCheck: true`
- `src/index.ts` — imports `NavMesh` / `NodeRef` / `findPath` from `navcat` and `crowd` from `navcat/blocks`

## Reproduce (local)

```sh
npm i
npm run check
```

## Reproduce (docker)

Clean-room reproduction in `node:22.22.2-bookworm-slim` (matches bjs):

```sh
docker build -t esm-extension .
docker run --rm esm-extension
```

The `npm i` happens at build time; `docker run` executes `npm run check` and prints the tsc errors.

## Expected

No errors — imports resolve cleanly.

## Observed (the bug)

TypeScript reports `TS2305` / `TS2307` for names that navcat clearly exports.
Root cause is inside the shipped `.d.ts` files: relative re-exports use
extensionless specifiers (`export * from './query'`) instead of the explicit
`.js` / `/index.js` specifiers required by `moduleResolution: NodeNext`, so
the barrel re-export chain never resolves the underlying named exports.

## Notes

- navcat's own source (`src/*.ts`, `blocks/*.ts`) already uses `.js` / `/index.js`.
  The regression is in the `.d.ts` emit — inline `typeof import(...)` paths and
  barrel `export * from ...` paths are landing extensionless in some files.
- Most ESM consumers don't hit this because they use `moduleResolution: Bundler`
  (Vite, Next, Bun) which is permissive about relative specifiers. This repro
  pins the strict Node.js ESM resolver, which is what TypeScript 6 enforces
  when `module`/`moduleResolution` is `NodeNext`.
- TypeScript is pinned to exact `6.0.3` for determinism. TS 5.x may report
  different diagnostics — the strictness was tightened in 6.
