# Metal C++ VSCode Template (macOS)

This project is a fully configured template for developing **C++ GPU applications** using **Metal Compute Shaders** and **CMake** in **Visual Studio Code**. It includes a simple example multiplying two matricies and it is primarly focused on **Apple Silicon (M1 - M4)**. This Proejct uses CMake and clangd. Sadly there is no intellisense for metal shaders. Therfore you will need to install Xcode and create a dummy project.

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

Then add it to your settings.json file:

```settings.json
{
    "clangd.path": "/opt/homebrew/opt/llvm/bin/clangd", #this should be the default directory, if not locate clangd and change this path
    "clangd.arguments": [
        "--compile-commands-dir=build",
        "--header-insertion=never"
    ],
    "files.associations": {
      "*.mm": "objective-cpp",
      "*.h": "objective-c",
      "*.metal": "metal"
    }
  }
```

---

### Install CMake (if not installed)

```bash
brew install cmake
```

---

## VSCode / XCode Setup

### 1. Recommended extensions

- [clangd](https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.vscode-clangd) — C++/Objective-C++ IntelliSense
- [CMake](https://marketplace.visualstudio.com/items?itemName=twxs.cmake) — suppoert for CMake in Visual Studio Code
- [Metal Shader Extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=doublebuffer.metal-shader) — Metal shader syntax highlighting

### 2. Confirm:

- Make sure that the C/C++ Extension from Microsoft is disabled
- Check if IntelliSense works in `.cpp` and `.mm` files
- It should look something like this:
  <img width="1048" height="290" alt="image" src="https://github.com/user-attachments/assets/7a9df249-7184-40f4-b9ca-1ae1574f9143" />

### 3. XCode

- Install [XCode](https://apps.apple.com/de/app/xcode/id497799835?mt=12) from the App Store
- Create a new Project
  1. Chose the `Command Line Tool` option an select the language: C++ or Objective-C (it does not really matter)
  2. Select the location for this project, its best to not do it in this project folder
  3. File -> Add Files to "Your Project name"... select your .metal shaders and select the action: `Refrence files in place` (this allowes you to edit the files in XCode and have it updated in VS Code)
  
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
gh repo create MyNewGPUProject --public --template=<your-username>/Metal_Cpp_VsCode_Template

```

---

## Author

Created by [Vincent Krebs](https://github.com/CoolML2022)
