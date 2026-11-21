# WeaveFoundry's Homebrew tap

Formulas for the [WeaveFoundry](https://github.com/weavefoundry) projects.

```sh
brew install weavefoundry/tap/weavec
brew install weavefoundry/tap/weaveffi
```

| Formula | Project |
| --- | --- |
| `weavec` | [WeaveC](https://github.com/weavefoundry/weavec): a memory-safe drop-in C and C++ compiler |
| `weaveffi` | [WeaveFFI](https://github.com/weavefoundry/weaveffi): idiomatic bindings for 11 languages from a C ABI library |

Each project's release workflow writes its own `Formula/<name>.rb` here,
pushing with the `HOMEBREW_TAP_TOKEN` organization secret; edit a formula
through its project's release, not by hand.
