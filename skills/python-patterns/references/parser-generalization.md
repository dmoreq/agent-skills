# Parser and Grammar Generalization Assessment

## Evidence collection

1. Map vocabulary loading, fragment generation, compiled patterns, span adapters, scanners, and downstream resolution. Check whether shared rules are reused or independently duplicated.
2. Find tests by imported symbols as well as filenames; behavior may be tested through cleaners and parser stages.
3. Run the focused component tests and record their exact scope. Separate statement coverage, branch coverage, semantic field accuracy, and domain coverage.
4. Inspect the golden checker alongside fixture metadata. Enumerate expected fields programmatically and compare them with assertions. An annotated field that the checker ignores provides no regression protection.
5. Inspect snapshot differences as set additions/removals. Treat snapshots as representation invariants, not semantic correctness tests; unchanged patterns can preserve bugs, and legitimate vocabulary expansion can invalidate snapshots.

## Generalization probes

Build a small synthetic matrix before proposing broad corpus claims:

- Accented, ASCII-folded, partially accented, and NFC/NFD-equivalent inputs.
- Case, repeated whitespace, abbreviation punctuation, and missing delimiters.
- Urban street/house forms, nested alleys, rural hamlets, apartment/subunit forms, and route/kilometer forms.
- Ambiguous tokens shared by addresses, venue names, and ordinary language.
- Previously unseen names combined with known syntax; separate compositional grammar from memorized name lists.
- Administrative hierarchy and temporal variants when the system claims reform support; trace these to the resolver rather than assigning all responsibility to grammar.

For each suspected issue, record input, intended contract, actual component output, caller normalization, and end-to-end effect when reproducible. Do not call a raw-input lexer failure an application defect when callers guarantee normalized input.

## Span and matching contracts

- Verify that reported spans slice the original input correctly after normalization. NFKC, case conversion, and combining-mark removal can change length; a function name claiming one-to-one transliteration is not proof.
- Check longest-match behavior separately from multi-label behavior. Global overlap suppression may intentionally return one entity while type-filtered queries return different entities.
- Verify regex-style adapters against the methods callers actually use, including capture-group offsets and error behavior.

## Efficiency assessment

- Separate cold initialization from warm scanning, no-match from dense-match inputs, and boolean existence checks from complete extraction.
- Account for normalization, emitted matches, sorting, overlap filtering, and object allocation. A linear automaton traversal does not make the complete API linear in input length alone.
- Use realistic bounded input lengths plus bounded stress cases. Report workload and measurement method, not an unqualified throughput claim.
- Prefer removing repeated work or early-returning existence checks over replacing a suitable algorithm without evidence.

## Reporting limits

Do not equate high line coverage with linguistic completeness. Pattern declarations execute at import, so grammar modules can show high statement coverage without exercising their semantic alternatives. Do not infer nationwide address accuracy from a synthetic probe matrix; reserve accuracy claims for independently labeled, stratified evaluation data.
