## GENERAL TASK
- explore @examples-dev/sdlprocessing
- peek a simple non implemented example
- explore SDLProcessing.jl codebase
- then, implement a SDLProcessing.jl version

## IMPORTANT
- Use SDLProcessing.jl API only
- Do not use other packages
- Do not add new files
- Follow the style of existing implemented examples
- Do not erase the initial commented section that describes the example
- use `SDLProcessing` this way:
    ```julia
    using SDLProcessing
    const P = SDLProcessing
    ```
- wrap the code in `P.onsetup() do ... end` and `P.ondraw() do ... end` blocks