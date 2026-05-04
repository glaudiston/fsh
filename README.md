
# 🚀 fsh (Functional Shell)

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Bash Version](https://img.shields.io/badge/Bash-4.0+-4eadf3.svg)
![Tests](https://img.shields.io/badge/Tests-Passing-brightgreen.svg)
![PRs Welcome](https://img.shields.io/badge/PRs-Welcome-blue.svg)

**Stop writing scripts. Start composing pipelines.**

`fsh` is a lightweight toolkit that brings the power of **Functional Programming (FP)** to the Bash shell. It allows you to treat your 
shell scripts like a series of mathematical transformations, using concepts like **Monoids, Maps, Filters, and Optional Chaining**.

Why write 50 lines of nested `if/else` and `for` loops when you can pipe your data through a beautiful, declarative flow?

---

## 🌟 What makes `fsh` awesome?

Bash is powerful, but it's imperative. `fsh` adds a functional layer on top, enabling you to:

*   **⛓️ Compose Pipelines:** Chain functions together where the output of one is the input of the next.
*   **🧬 Monadic Logging:** Track every single transformation in your pipeline automatically without polluting your logic with `echo` 
statements.
*   **🛡️ Optional Chains:** Avoid "null" or "empty" errors by using `runOptional`—if a value disappears, the chain simply stops safely.
*   **🧩 JSON First:** Deep integration with `jq` to handle structured data with ease.
*   **♻️ Pure-ish Logic:** Implement recursion and higher-order functions (map, filter, iterate) directly in your shell.

---

## 🛠️ Quick Start (For Everyone)

### 1. Installation
Since `fsh` is a set of shell functions, you don't "install" it in the traditional sense. Just clone the repo and source the files in 
your script:

```bash
# Clone the project
git clone https://github.com/yourusername/fsh.git
cd fsh

# In your script, just add:
source ./fsh.sh
source ./monoid.sh
```

### 2. Your First Pipeline (The "Noob" Guide)
Imagine you want to generate a list of numbers, keep only the ones greater than 0, turn them into JSON objects, sort them, and take the 
top one. 

**The `fsh` way:**
```bash
iterate 0 '[ $1 -lt 5 ]' echo | \
filter ' [ $1 -gt 0 ] ' | \
map ' echo { "id": $1, "s": $1 } ' | \
sort_json .s desc | \
take 1
```
**What's happening here?**
1. `iterate`: Creates numbers 0 to 4.
2. `filter`: Throws away the 0.
3. `map`: Transforms `4` $\rightarrow$ `{"id": 4, "s": 4}`.
4. `sort_json`: Sorts the JSON list by the field `.s` in descending order.
5. `take 1`: Grabs the top result.

---

## 📖 API Reference

### ⚡ Core Functional Tools (`fsh.sh`)
| Function | Description | Example |
| :--- | :--- | :--- |
| `map` | Transforms every item in the stream. | `map 'echo $1 * 2'` |
| `filter` | Keeps items that match a condition. | `filter '[ $1 -gt 10 ]'` |
| `iterate` | Generates a sequence based on a condition. | `iterate 0 '[ $1 -lt 10 ]' echo` |
| `sort_json` | Recursively sorts JSON objects by a key. | `sort_json .price asc` |
| `take` | Grabs the first $N$ elements. | `take 5` |

### 🧬 Monoid & Monad Tools (`monoid.sh`)
| Function | Description | Example |
| :--- | :--- | :--- |
| `runOptional` | Executes a function ONLY if the input is not empty. | `runOptional getUser \| runOptional getEmail` |
| `withLogs` | Starts a "Logging Monad" to track changes. | `echo "data" \| withLogs` |
| `runWithLogs` | Performs an action and records it in the log history. | `runWithLogs calculateTax` |
| `flatMap` | Maps a value into multiple values and flattens them. | `flatMap "x" "y"` |

---

## 🧪 Running Tests

We believe in stability. `fsh` comes with a built-in test suite to ensure everything is working perfectly.

```bash
chmod +x fsh_test.sh
./fsh_test.sh
```

**Expect output:**
`➔ Functional Pipelines... PASS ✅`
`➔ Monoid & Optional Patterns... PASS ✅`
`➔ Logging Monads... PASS ✅`

---

## ⚖️ License

Distributed under the **MIT License**. See `LICENSE` for more information.

---

## 🤝 Contributing

Got a cool idea for a new functional operator?
1. Fork the project.
2. Create your feature branch.
3. Commit your changes.
4. Push and open a PR!

**Happy Piping! 🚀**
