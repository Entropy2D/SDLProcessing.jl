# SDLProcessing

[![CI](https://github.com/josePereiro/Entropy2D/actions/workflows/CI.yml/badge.svg)](https://github.com/josePereiro/Entropy2D/actions/workflows/CI.yml)
<!-- TODO: Make CODECOV work -->
<!-- [![Coverage](https://codecov.io/gh/josePereiro/Entropy2D/branch/main/graph/badge.svg)](https://codecov.io/gh/josePereiro/Entropy2D) -->

Our goal is to create a tool similar to [Processing](https://processing.org) but in Julia. But we do not intent to replicate exactly its API.

> DISCLAIMER: We are not part of the [Processing](https://processing.org) project.

## Examples

### randomWalker

A particle randomly walking... click the screen for reseting the simulation.
The particle traces the path traveled during inter frame time.
Close the window to end.

To test it run this:
```batch
julia --project examples/randomWalker.jl
```
