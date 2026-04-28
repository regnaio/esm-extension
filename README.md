# `navcat` `NodeNext` module resolution repro

## Background

### Node Docs
[ESM: Mandatory File Extensions](https://nodejs.org/api/esm.html#mandatory-file-extensions)
> A file extension must be provided when using the import keyword to resolve relative or absolute specifiers. Directory indexes (e.g. './startup/index.js') must also be fully specified.

### Google AI Overview
> In JavaScript ECMAScript Modules (ESM), file extensions are mandatory when using relative or absolute import specifiers in most modern runtimes.
> 
> TypeScript Behavior: When writing ESM in TypeScript, you must often use the .js extension in your import statements even if the source file is .ts. This is because TypeScript does not transform the import path during compilation.

### Why this may have not been an issue before
> Bundlers: Tools like Webpack, Vite, or esbuild can be configured to resolve extensions automatically, allowing you to omit them during development.

---

## Node Docker environment (optional):
```shell
docker build -t esm-dev .

docker run -it --rm --name esm-dev-container -v ${PWD}:/app esm-dev /bin/bash
```

---

## Repro Steps:
```shell
npm i

npm run build
```

---

## Sample Errors:
```shell
node_modules/mathcat/dist/index.d.ts:2:15 - error TS2834:
Relative import paths need explicit file extensions in ECMAScript imports when '--moduleResolution' is 'node16' or 'nodenext'.
Consider adding an extension to the import path.

2 export * from './types';
                ~~~~~~~~~

node_modules/mathcat/dist/index.d.ts:3:23 - error TS2835:
Relative import paths need explicit file extensions in ECMAScript imports when '--moduleResolution' is 'node16' or 'nodenext'.
Did you mean './vec2.js'?

3 export * as vec2 from './vec2';
                        ~~~~~~~~
```
