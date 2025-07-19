# Metal + C++ VSCode Template (macOS)

This project is a fully configured template for developing **C++ GPU applications** using **Metal Compute Shaders** and **CMake**, specifically designed for **macOS with Apple Silicon (M1–M4)** in **Visual Studio Code**.

---

## Project Structure

```
.
├── .vscode/           # VSCode settings (clangd, includes, frameworks)
├── build/             # Build directory (ignored by Git)
├── shaders/           # Metal shader files (*.metal)
├── src/               # C++ and Objective-C++ source files
├── CMakeLists.txt     # CMake build configuration
├── README.md          # Project instructions
└── .gitignore         # Ignored files and directories
```

---

## Prerequisites (macOS)

### Install Xcode command-line tools (includes Metal)

```bash
xcode-select --install
```

---

### Install clangd (IntelliSense for C++/ObjC++) using Homebrew

```bash
brew install llvm
```

Then add it to your shell profile:

```bash
echo 'export PATH="/opt/homebrew/opt/llvm/bin:$PATH"' >> ~/.zprofile
source ~/.zprofile
```

Check installation:

```bash
which clangd
```

---

### Install CMake (if not installed)

```bash
brew install cmake
```

---

## VSCode Setup

### 1. Recommended extensions

- `clangd` — C++/Objective-C++ IntelliSense
- `CMake Tools` — configure, build and run from VSCode
- `Better Metal` — Metal shader syntax highlighting

### 2. Confirm:

- Bottom right of VSCode shows: `clangd`
- IntelliSense works in `.cpp` and `.mm` files

---

## Build & Run the Project

### 1. Configure CMake

```bash
cmake -S . -B build
```

### 2. Build the project

```bash
cmake --build build
```

### 3. Run (e.g. matrix multiplication test)

```bash
./build/MatrixMultiply
```

---

## Compile Metal Shaders Manually (optional)

This is normally handled by CMake, but can be done manually:

```bash
metal -c shaders/matrix_multiply.metal -o shaders/matrix_multiply.air
metallib shaders/matrix_multiply.air -o shaders/matrix_multiply.metallib
```

---

## Notes

- The `build/` folder is ignored via `.gitignore`. Run CMake after cloning.
- The `.vscode/` folder is included so that users get instant IntelliSense and working Metal headers.
- `.mm` files are **Objective-C++** and are required to interface with Metal APIs inside C++.

---

## CPU vs GPU Performance Comparison

This template includes:

- CPU-based matrix multiplication (C++)
- GPU-based version using Metal compute shaders

You can measure runtime using `std::chrono` or `mach_absolute_time()` to compare performance.

---

## Create New Project from Template (GitHub)

This repository is marked as a **GitHub template**.

To create a new project:

Click **"Use this template"**  
Or use the GitHub CLI:

```bash
gh repo create MyNewGPUProject --public --template=<your-username>/MyMetalTemplate
```

---

## Author

Created by [Vincent Krebs](https://github.com/CoolML2022)
