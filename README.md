# SDLProcessing

<!-- [![CI](https://github.com/Entropy2D/SDLProcessing.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/Entropy2D/SDLProcessing.jl/actions/workflows/CI.yml) -->
<!-- TODO: Make CODECOV work -->
<!-- [![Coverage](https://codecov.io/gh/Entropy2D/SDLProcessing.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/Entropy2D/SDLProcessing.jl) -->

Our goal is to create a tool similar to [Processing](https://processing.org) but in Julia. Although we do not intent to replicate exactly its API.

> DISCLAIMER: We are not part of the [Processing](https://processing.org) project.

## Examples

### randomWalker

A particle randomly walking. The particle traces the path traveled during the interframes time. Play with the mouse controls (left, right, and wheel) for interacting with the simulation.
Close the window to exit.

To test it run this:
```batch
julia --project examples/randomWalker.jl
```

### confetti

Just play with the mouse controls.

To test it run this:
```batch
julia --project examples/confetti.jl
```
