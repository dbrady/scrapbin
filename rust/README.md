# Rust

Notes from setting up Rust on the Linux workstation (2026-11-13, Rust 1.100.0).

## Vocabulary

- **rustup**: installs and manages Rust toolchains, like rbenv/asdf for Ruby.
  Lives in `~/.rustup`.
- **cargo**: rubygems + bundler + rake. Handles dependencies from
  [crates.io](https://crates.io), builds and tests projects, and installs CLI
  tools from source with `cargo install`. Lives in `~/.cargo/bin`.
- **crate**: a Rust package (a gem).

## Installing

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
```

This installs the stable toolchain: `cargo`, `rustc`, `rustfmt`, `clippy` and
offline docs. `rust-analyzer` (the editor language server for autocomplete and
inline errors) is NOT in the default profile; add it with
`rustup component add rust-analyzer`. The installer also appends `. "$HOME/.cargo/env"` to `~/.bashrc`,
`~/.profile` and `~/.bash_profile` so cargo is on PATH. In an already-open
shell, run `source ~/.cargo/env`.

The C toolchain (`build-essential`) must be installed too; rustc uses `cc` as
its linker.

## Working on a project

```bash
cargo new myapp          # new project: Cargo.toml (like a Gemfile) + src/main.rs
cargo run                # build (debug) and run
cargo build --release    # optimized binary → target/release/myapp
cargo add serde          # add a crate dependency (edits Cargo.toml)
cargo clippy             # lint for common mistakes
cargo fmt                # format the code
cargo test               # run tests
```

Debug builds land in `target/debug/`, release builds in `target/release/`. The
release binary is a single self-contained file: copy it to another Linux
x86-64 machine and it runs without Rust installed there. `Cargo.lock` is like
`Gemfile.lock`; commit it for binaries.

## Editor support (rust-analyzer)

rust-analyzer is the Rust language server: autocomplete, go-to-definition,
inline type hints and errors as you type. Install it as a rustup component so
it stays in sync with the compiler:

```bash
rustup component add rust-analyzer
rust-analyzer --version  # → ~/.cargo/bin/rust-analyzer
```

`rustup update` keeps it current along with the rest of the toolchain. Point
your editor's LSP client at it:

- **VS Code**: install the "rust-analyzer" extension. It bundles its own copy
  of the server by default; to use the rustup one instead, set
  `"rust-analyzer.server.path"` to the absolute path from `which rust-analyzer`.
- **Emacs**: eglot (built in) and lsp-mode both find `rust-analyzer` on PATH
  automatically when you open a `.rs` file.
- **Neovim**: `vim.lsp.enable('rust_analyzer')` with nvim-lspconfig installed.

It works on the project containing the open file (the nearest `Cargo.toml`), so
open files from inside a cargo project, not loose `.rs` files.

## Learning / docs

```bash
rustup doc --book        # "The Rust Programming Language", offline
rustup doc --std         # standard library API docs, offline
cargo doc --open         # docs for your project AND all its dependencies
```

- The Book: https://doc.rust-lang.org/book/ (start here)
- Rust by Example: https://doc.rust-lang.org/rust-by-example/
- Crate docs: https://docs.rs (every crates.io crate's API docs)

## Updating

Stable Rust ships a new version every six weeks.

```bash
rustup check     # what's out of date? (read-only)
rustup update    # update toolchains and rustup itself
```

Tools installed with `cargo install` are NOT updated by `rustup update`. They
are compiled binaries; to update one, reinstall it:

```bash
cargo install jless --root ~/.local          # no-op if already latest
cargo install --list --root ~/.local         # what's installed there
```

## Installing CLI tools

Check apt first (`apt-cache policy <tool>`). Plenty of Rust tools are packaged
(ripgrep, fd-find, bat). Otherwise:

```bash
cargo install <crate> --root ~/.local
```

`--root ~/.local` puts the binary in `~/.local/bin` (already on PATH) instead of
`~/.cargo/bin`, so personal tools live in one place regardless of what language
they're written in.

### When a build fails with `unable to find library -lfoo`

The crate links against a C system library and needs its headers/link stubs.
Install the `-dev` package and rerun:

```bash
sudo apt-get install libfoo-dev
```

## Installed so far

### jless (JSON pager/navigator)

https://jless.io. Vim-style keys: `j`/`k` move, `h`/`l` collapse/expand or go
to parent/child, `J`/`K` jump between siblings, `c`/`e` collapse/expand all
below, `space` toggles, `/` searches, `yp` copies the jq path of the current node.

```bash
sudo apt-get install libxcb1-dev libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev
cargo install jless --root ~/.local
```

The libxcb packages are needed because jless's clipboard support (`yp`) links
against X11's libxcb; without them the build fails at the final link step.

The build warns that `xcb v0.8.2` "contains code that will be rejected by a
future version of Rust." That warning is about jless's old clipboard
dependency, not about our toolchain. If a future `cargo install jless` stops
compiling, this is why; the fix would be a newer jless release, or grabbing a
prebuilt binary from
https://github.com/PaulJuliusMartinez/jless/releases.

## Uninstalling

```bash
cargo uninstall jless --root ~/.local   # one tool
rustup self uninstall                   # the whole toolchain (~/.rustup, ~/.cargo)
```

Afterward, check the three dotfiles for leftover `. "$HOME/.cargo/env"` lines
and delete any that remain.
