<div align="center">

<img src="assets/ereaser.png" width="360" alt="Baldspot">

# Baldspot

*He looks at the whiteboard. He erases some blocks. The product ships on time.*

Inspired by **[ponytail](https://github.com/DietrichGebert/ponytail)** — the lazy-senior-**dev** mode for code. Baldspot is its senior-**architect** counterpart, for design and architecture documents.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
&nbsp;[![skills.sh](https://skills.sh/b/daTokenizer/baldspot)](https://skills.sh/daTokenizer/baldspot)

</div>

---

Agents over-architect specs the same way they over-write code: a new service where a config would do, a plugin system with one plugin, a "future-proof" abstraction nobody asked for, a §7 wishlist dressed up as design. Baldspot is a persistent mode that reads a design the way a senior architect does — and cuts it to what's load-bearing.

Lazy means efficient, not careless. The least troublesome component is the one you don't add. The cheapest capability is the one that already exists. **New is the enemy.**

## The ladder

Stop at the first rung that holds:

1. **Does this capability need to exist at all?** Nobody asked / speculative → cut it.
2. **Does an existing component already do it?** Use it. Name it. Don't roll your own.
3. **Can an existing component be extended?** Extend before you build, but only while it stays one thing.
4. **A new responsibility?** A new component. Don't bolt a second job onto one that already does its own.
5. **Does deployed infra give it for free?** A datastore, queue, API, config you already run — before new machinery.
6. **Can it be one component / one doc / one diagram?** Keep it one.
7. **Only then:** the minimum new design that works — built reusably.

## Before / after

A real spec proposed, under one capability:

> a new TimescaleDB store **and** a Kapacitor/Influx alerting stack **and** a Redis-backed feature-flag manager **and** a §7 listing ML-driven thresholds, multi-tenant schemas, and a future GraphQL API.

Count the *and*s: four components wearing one name. Baldspot's read:

```
store → cut: Kapacitor/Influx (regression detection is a scheduled SQL query over the hypertable),
             Redis flag manager (no user story uses flags), the §7 wishlist (no mechanism behind it).
       reuse: check the existing telemetry store before standing up a second time-series DB.
add when: a real second consumer needs them.
```

One line per finding, location and replacement named. The doc's best outcome is getting shorter.

## The maxims

**New is the enemy** · **Don't roll your own** · **Do one thing, and do it well** · **less logic = fewer bugs** · **Fail Correctly**

## Install

**Claude Code** (plugin):

```
/plugin marketplace add daTokenizer/baldspot
/plugin install baldspot
```

**Manual** (any skill-capable agent): copy `skills/baldspot` and `skills/baldspot-review` into `~/.claude/skills/`.

## Modes & commands

| Invoke | What it does |
|--------|--------------|
| `baldspot` | Persistent mode. Governs how you write/edit any design doc. `/baldspot lite\|full\|ultra` sets intensity (default **full**). Off with "stop baldspot". |
| `baldspot-review` | One-shot. Audits an existing spec/PRD/HLD/RFC for over-architecture: one line per finding tagged `cut`/`reuse`/`extend`/`standard`/`wishlist`/`split`/`shrink`. Lists, doesn't apply. |

## When NOT to be lazy

A "simpler" design that drops these is unfinished, not simpler — baldspot never cuts them:

- **Fail correctly** — kill switches, thresholds, margins; a known failure mode.
- **Input validation** at trust boundaries — the last line of defence against upstream bugs.
- **The actionability chain** — every view ties an effect back to a cause the user can act on.
- **The user-domain interface** — names stay in the user's vocabulary, stable across refactors.
- Anything the user explicitly requested.

## The doctrine behind it

Baldspot is the reflex; the manifestos are the why.

- **[The System Design Manifesto](https://arch.adamlev.com)** — the architecture principles baldspot enforces.
- **[The Data Modeling Manifesto](https://data.adamlev.com)** — its data/schema sibling.

## License

MIT. The shortest license that works.
