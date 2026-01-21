# How to Run Performance Tests

To run Julia scripts within this project, especially for performance testing, always execute them from the package's root directory using the `--project` flag. This ensures that the script runs within the project's defined environment, loading the correct dependencies and versions.

## Running a Script

To run a script, use the following command structure:

```bash
julia --project examples/<your-script-name>.jl
```

For instance, to run the `test-script-empty-loop.jl` example:

```bash
julia --project examples/test-script-empty-loop.jl
```

## Extracting Performance Metrics

Scripts designed for performance testing will print metrics directly to the console. Look for output lines that indicate performance, such as `fps: <number>` for frame rates.

Example output and how to interpret it:

```
fps: 56.7645738237543
fps: 56.2408222647267
fps: 35.97238193561118
fps: 36.54034028191887
fps: 58.35626462891715
```

In this case, the mean frame rates are listed after "fps:". Collect these values for analysis.
