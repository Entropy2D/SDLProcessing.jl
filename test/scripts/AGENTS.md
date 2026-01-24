## Test-scripts for julia and p5js

at the folder we have tests-scripts for julia and for p5js.
- We will create equivalent examples for both implementations.:
- test-scripts work by printing in the console the stats metrics or test results.
    - for instance, fps (frames per second)
- the tests-scripts will over terminate automatically after a short time.
- At the beginning of the script file we have a comment with instructions on how to use the test-script.
- test-scripts can accept command line arguments.

## How to run julia test-scripts
-  run the scripts using `julia --project` from the package root folder.
    - for instance: julia --project test/scripts/jl/test-script-walkers.j --nwalkers=1000

## How to run p5js test-scripts
- #TODO