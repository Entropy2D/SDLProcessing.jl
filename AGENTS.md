## General

- Our goal is to create a Julia implementation of the Processing language, similar to p5.js.
- We will try to reach feature parity with p5.js as much as possible.
- but, we also will do stuff the Julian way, leveraging Julia's strengths.
- We will have tests which are just like p5.js examples, so we can be sure we are on the right track.
- We will base the package on SDL2 via the SDL2.jl package.

## Recources 
- For knowing more about Processing and p5.js, you can:
    - check `refs/p5js/src` for the source code of p5.js
        - our goal is to reach feature parity with it
    - read `https://processing.org/`
    - read `https://p5js.org/reference/`
- For design notes, see `@notes/index/index.md`.
    - Follow index links to find notes about specific topics.
- For knowing more about `SimpleDirectMediaLayer.jl`, you can:
    - check `refs/SimpleDirectMediaLayer/src`
- For an example of using `SimpleDirectMediaLayer.jl`, you can:
    - check `refs/Gloria/src`

## Important
- `import`s are done in the main package file `src/SDLProcessing.jl`.
- do not `export` anything, we will use `const P = SDLProcessing` pattern and qualified names.
- run julia code as `julia --project ...` from the package root folder.
    - this ensures the correct environment is used.
- test scripts are `examples/test-script-*.jl`.
    - see `notes/index/run-performance-tests.md` for instructions on how to run and interpret them.
