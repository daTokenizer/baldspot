---
name: boldspot-review
description: >
  Design-doc review focused exclusively on over-architecture. Finds what to
  cut, reuse, or simplify in a spec/PRD/HLD/RFC: components that needn't exist,
  new things an existing one already covers, rolled-your-own where a standard
  exists, future-proofing with no mechanism behind it, bloated sections. One
  line per finding: location, what to cut, what replaces it. Use when the user
  says "boldspot-review", "review this design for over-architecture", "what can
  we cut from this spec", "is this over-architected", or invokes
  /boldspot-review. Complements correctness review, this one only hunts
  complexity. The companion one-shot to the boldspot persistent mode.
---

Review a design doc (spec / PRD / HLD / RFC) for over-architecture. One line
per finding: location, what to cut, what replaces it. The doc's best outcome
is getting shorter. New is the enemy — less design = less to build, maintain,
and be paged for.

## Format

`<file>:L<line>: <tag> <what>. <replacement>.` One line each.

Tags:

- `cut:` capability, section, or component that needn't exist — nobody asked, no user effect. Replacement: nothing.
- `reuse:` new component or data model an existing one already covers. Name the existing one.
- `extend:` new thing that should extend an existing component, not stand up a new one — when it is the same single responsibility done more fully. Name what it extends.
- `standard:` rolled-your-own where an industry standard or already-deployed tool exists. Name it.
- `wishlist:` future-proofing with no enabling mechanism in this spec. Move it to Non-Requirements.
- `split:` one component, capability, or doc doing two things — if you need the word *and* to say what it does, it is two. Name the two. (This is also the line for `extend`: extend only while it stays one thing.)
- `shrink:` same design, fewer words / boxes / sections. Show the shorter form.

## Examples

❌ "This TelemetryRouter abstraction seems like it might be adding more
indirection than necessary, have you considered whether the pluggable backend
design is warranted given the current requirements?"

✅ `telemetry-storage.md:L40-58: standard: custom pub/sub for fan-out to 2 sinks. Existing nextclusterd stream already does it.`

✅ `user-luts.md:L12: reuse: new LutRegistry component. application-key already hashes config inputs — register there.`

✅ `tracing.md:L77-90: wishlist: "future TCP/IP transport" with no abstraction in this spec enabling it. Move to Non-Requirements.`

✅ `sysconfig.md:L4: split: "configuration AND validation" capability. Two docs: sysconfig-format, sysconfig-validation.`

✅ `artifact-store.md:L120-145: cut: per-node GC scheduler section. No user effect; the existing retention clock covers it. Nothing replaces it.`

✅ `save-state.md:L33-51: shrink: three prose paragraphs restating the API. One code block of the struct.`

## Scoring

End with the only metric that matters: `net: -<N> sections / components / lines possible.`

If there is nothing to cut, say `Lean already. Ship.` and stop.

## Boundaries

Scope: over-architecture and complexity only. Correctness, security, and
performance gaps are out of scope — route them to a normal review pass.

NEVER flag these as cuttable — they are load-bearing, not bloat:

- **Fail-Correctly knobs** — kill switches, max/min thresholds, noted margins of error. These keep a failure local instead of cascading.
- **Input validation at trust boundaries** — the last line of defence against upstream bugs.
- **The actionability chain** — any view/metric tracing an observed effect back to a cause the user can act on. Cutting the cause-link is removing the feature, not simplifying it.
- **The user-domain interface** — command/field/error names in the user's vocabulary, stable across refactors.
- **Anything the user explicitly requested.** If they asked for the fuller design, it stays.

One-shot: lists findings only, applies no fixes. Does not post anything. "stop
boldspot-review" or "normal mode": revert to verbose review style.
