<div align="center">

# Boldspot

*He's seen the plugin layer that never got a second plugin. He deletes the section. The design still ships.*

Inspired by **[ponytail](https://github.com/DietrichGebert/ponytail)** — the lazy-senior-**dev** mode for code. Boldspot is its senior-**architect** counterpart, for design and architecture documents.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
&nbsp;[![Works with Claude Code](https://img.shields.io/badge/works%20with-Claude%20Code-d97757.svg)](https://claude.com/claude-code)
&nbsp;[![Stars](https://img.shields.io/github/stars/daTokenizer/boldspot?style=social)](https://github.com/daTokenizer/boldspot/stargazers)

</div>

---

Agents over-architect specs the same way they over-write code: a new service where a config would do, a plugin system with one plugin, a "future-proof" abstraction nobody asked for, a §7 wishlist dressed up as design. Boldspot is a persistent mode that reads a design the way a senior architect does — and cuts it to what's load-bearing.

Lazy means efficient, not careless. The best component is the one you don't add. The cheapest capability is the one that already exists. **New is the enemy.**

## The ladder

Stop at the first rung that holds:

1. **Does this capability need to exist at all?** Nobody asked / speculative → cut it.
2. **Does an existing component already do it?** Use it. Name it. Don't roll your own.
3. **Can an existing component be extended?** Extend, don't add.
4. **Does deployed infra give it for free?** A datastore, queue, API, config you already run — before new machinery.
5. **Can it be one component / one doc / one diagram?** Keep it one.
6. **Only then:** the minimum new design that works — built reusably.

## Before / after

A real spec proposed, under one capability:

> a new TimescaleDB store **and** a Kapacitor/Influx alerting stack **and** a Redis-backed feature-flag manager **and** a §7 listing ML-driven thresholds, multi-tenant schemas, and a future GraphQL API.

Boldspot's read:

```
store → cut: Kapacitor/Influx (regression detection is a scheduled SQL query over the hypertable),
             Redis flag manager (no user story uses flags), the §7 wishlist (no mechanism behind it).
       reuse: check the existing telemetry store before standing up a second time-series DB.
add when: a real second consumer needs them.
```

One line per finding, location and replacement named. The doc's best outcome is getting shorter.

## The maxims

**New is the enemy** · **Don't roll your own** · **less logic = fewer bugs** · **Fail Correctly**

## Install

**Claude Code** (plugin):

```
/plugin marketplace add daTokenizer/boldspot
/plugin install boldspot
```

**Manual** (any skill-capable agent): copy `skills/boldspot` and `skills/boldspot-review` into `~/.claude/skills/`.

## Modes & commands

| Invoke | What it does |
|--------|--------------|
| `boldspot` | Persistent mode. Governs how you write/edit any design doc. `/boldspot lite\|full\|ultra` sets intensity (default **full**). Off with "stop boldspot". |
| `boldspot-review` | One-shot. Audits an existing spec/PRD/HLD/RFC for over-architecture: one line per finding tagged `cut`/`reuse`/`extend`/`standard`/`wishlist`/`split`/`shrink`. Lists, doesn't apply. |

## When NOT to be lazy

A "simpler" design that drops these is unfinished, not simpler — boldspot never cuts them:

- **Fail correctly** — kill switches, thresholds, margins; a known failure mode.
- **Input validation** at trust boundaries — the last line of defence against upstream bugs.
- **The actionability chain** — every view ties an effect back to a cause the user can act on.
- **The user-domain interface** — names stay in the user's vocabulary, stable across refactors.
- Anything the user explicitly requested.

## The doctrine behind it

Boldspot is the reflex; the manifestos are the why.

- **[The System Design Manifesto](https://arch.adamlev.com)** — the architecture principles boldspot enforces.
- **[The Data Modeling Manifesto](https://data.adamlev.com)** — its data/schema sibling.

## License

MIT. The shortest license that works.
