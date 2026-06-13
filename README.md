# 🚀 English++ (EPP Runtime Environment)

Welcome to **English++**, a lightweight, high-performance programming language ecosystem designed to provide clean, minimalist syntax as an independent, portable competitor to Python. 

Built entirely to minimize local computer dependency structures, English++ runs natively inside isolated Windows terminal frameworks without needing heavy system installations or runtimes.

---

## 🛠️ Key Features
* **Zero Host Dependencies**: Fully portable runtime infrastructure—drop it on a USB flash drive and run your scripts anywhere.
* **Simplified Variables & Decimals**: Native support for integer states and multi-tier floating-point arithmetic.

---

## 📂 Project Architecture Layout
To maximize workspace organization, English++ maintains a pristine root workspace directory by containing all core modules, packages, and environment assets completely inside isolated system directories:

```text
📁 PocketSuite-Hub/
 ├── 📄 English++.bat        # The Core Language Compiler/Interpreter Engine
 └── 📁 Lib/                 # The Standard Library Directory
      ├── 📄 math.epp        # Core Floating-Point Math Constants
      ├── 📄 sys.epp         # Live Machine Environment & Profile Variables
      └── 📁 site-packages/  # Target Directory for Third-Party EPP Modules
```

---

## 💻 Code Syntax Showcase
Writing programs in English++ is incredibly clean and intuitive. Here is a look at what an `.epp` file looks like when executed through our engine:

```text
# 1. Mount standard dependencies
include sys
include math

print --- Welcome to English++ ---
print Active User Profile:
print user

# 2. Compute float calculations natively
radius = 2.5
area = radius * radius
total_area = area * pi

print Computed Room Space:
print total_area

# 3. Branch decisions using conditionals
if total_area == 0
print Error: Room cannot be empty!
else
print Success: Calculation complete.
endif
```

---

## 🤝 How to Contribute
We are actively building out the initial release of the language runtime. If you are an open-source developer who loves compiler architecture, systems scripting, or developer tool optimization, we want your help!

### Core Roadmap Focus:
1. **The EPP Package Manager**: Implementing an automated tool (`epm.bat`) to fetch, compile, and place packages directly into the `Lib/site-packages/` path.
2. **Loop Iterators**: Injecting support for continuous processing routines (like `while` loop conditions).
3. **String Concatenation**: Designing a clean character binding syntax to link text variables together natively.
4. **Dynamic Scopes**: Robust conditional parsing using native `if`, `else`, and `endif` logic paths.
5. **Standard Library Mounting**: Modular architecture that loads package configurations from local library paths automatically.

Check out our **GitHub Issues** tab to grab a task and help make English++ the ultimate portable alternative!
