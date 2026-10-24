# Verifying Subagent Chains and Multi-Stage Workflows

When a task is executed as implement → review → fix → review rounds, the parent agent owns the record:

1. **Independent Verification**: After each child completes, run the acceptance commands yourself in the main session and compare against the numbers the plan expected, not against the child's table.
2. **Explicit Deviation Approval**: Treat a child's stated deviation as a request for a decision, not as a completed change. Decide in the main session, write it into a dated plan revision, and only then dispatch the fix — otherwise the deviation becomes the new baseline unnoticed.
3. **Measured vs. Theoretical Benefit**: When a fix's benefit is theoretical and its cost is measured (a guard that removes real keys but only catches a case not present in the data), revert the guard and record the residual behavior as a pinned known-bad test. Do not keep a change whose only evidence is an invented example.
4. **Count Invariants**: Enforce at least one count invariant across any rebuild (artifact line counts or a content digest). A move in that count is a defect report, not a number to update.
5. **Review Revision Matching**: Pass the reviewer the revision you will actually ship, and check the SHA it names. A review requested before an `--amend`, a rebase, or one more fix describes a revision that no longer exists. Read the SHA out of the verdict and compare it to HEAD: identical means the verdict applies; different means re-request against the new revision. Sending a verdict is not the same as having a verdict.
6. **Asynchronous Deliveries**: A verdict arriving is not a verdict being read. Deliveries are asynchronous and can land after you have moved on, or be superseded by background work. Pull the reply from the reviewer's log/state store and confirm it answers your message before acting on it or reporting a gate as passed.
