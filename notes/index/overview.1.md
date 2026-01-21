# Overview 010: Project Invariants and Design

This document summarizes the foundational principles for the `SDLProcessing.jl` project, based on our initial discussion.

## 1. Core Goal & Philosophy

-   **Primary Objective**: Create a Julia implementation of the [Processing](https://processing.org/) language, with core feature-parity and API design inspired by [p5.js](https://p5js.org/reference/).
-   **Target Audience**: Individuals familiar with the Processing/p5.js workflow. The transition to the Julia implementation should be as seamless as possible.
-   **The Julian Way**: While aiming for p5.js compatibility, the implementation must not conflict with Julia's idioms and best practices. We will find a creative balance between the two.

## 2. Architecture & Technical Decisions

-   **State Management**: We will embrace the global state model that is central to Processing. Functions like `fill()`, `stroke()`, etc., will modify a persistent global state that affects subsequent drawing operations.
-   **Dependencies**: The project will have minimal dependencies. The core dependency is `SimpleDirectMediaLayer.jl` for all graphics, windowing, and event handling.
-   **Abstraction**: All low-level SDL2 details will be abstracted away from the end-user. The public-facing API should be clean and high-level, mirroring p5.js.
-   **Resource Management**: We will follow Julia's best practices for memory management. Native Julia objects will wrap low-level SDL resources, and finalizers will be used to ensure proper cleanup and prevent memory leaks.
-   **Existing Code**: The implementation currently in the`_DEPRECATED` directories will be discarded to allow for a fresh start. However, it will be studied to extract useful patterns and ideas, particularly regarding the wrapping of SDL objects.

## 3. User-Facing API & Workflow

-   **Sketch Structure**: The primary workflow will be familiar to p5.js users. A sketch will be defined by two user-provided functions hooked at specific lifecycle points:
    -   `onsetup(f::Function)`: Runs once at the beginning of the application.
    -   `ondraw(f::Function)`: Runs repeatedly in a loop to render each frame.
    -   A `run_sketch()` (or similarly named) function provided by our library will orchestrate the execution of these functions. No complex macros will be used for this.
-   **Event Handling**: The system for handling user input (e.g., `mousePressed`, `keyPressed`) will be designed to be as flexible as possible, allowing the user freedom in how they structure their event logic. The exact mechanism will be detailed later.
-   **Coordinate System**: We will adopt the p5.js standard: a 2D coordinate system with the origin (0,0) in the top-left corner of the canvas. Transformation functions (`translate`, `rotate`, `scale`) will modify the global state.
