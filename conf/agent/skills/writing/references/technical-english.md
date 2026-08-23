# Plain technical English

Use these rules for documentation, procedures, error messages, release notes,
API text, comments, and other technical prose. They draw from ASD-STE100 Issue 9
and George Orwell's "Politics and the English Language." They are a practical
writing guide, not an STE certification.

Sources:

- [ASD-STE100](https://asd-ste100.org/)
- [STE writing skill and experiment](https://github.com/woosal1337/blog/tree/main/videos/ep01-the-cure-for-ai-slop)
- [George Orwell, "Politics and the English Language"](https://www.george-orwell.org/Politics_and_the_English_Language/0.html)

## Start with meaning

Orwell's main argument goes beyond a banned-word list. Ready-made phrases let a
writer avoid choosing an exact meaning. They replace concrete images with
abstractions, simple verbs with padded phrases, and direct claims with vague or
pretentious language.

Before revising a sentence, ask:

- What does it need to say?
- Which words express that meaning exactly?
- Would a concrete example make it clearer?
- Can it say the same thing with fewer words?
- Does any phrase sound familiar because it is stale rather than accurate?

Let the meaning choose the words. Do not choose a familiar phrase and bend the
meaning to fit it.

## Orwell's rules

Orwell gave six fallback rules for cases where instinct fails:

1. Do not use a metaphor, simile, or figure of speech that is common in print.
2. Do not use a long word when a short word works.
3. Cut every word that can be cut.
4. Use active voice when possible.
5. Prefer an everyday English word to jargon or an unnecessary foreign or
   scientific term.
6. Break any rule before writing something ugly, unclear, or inhumane.

Apply the principles rather than treating them as a mechanical purity test.
Orwell also rejected fake simplicity and a fixed "standard English." Precise
technical terms are better than familiar but inaccurate substitutes.

## Plain technical mode

### Terms and words

- Use one term for one thing and one meaning for each term.
- Repeat the established noun. Do not rotate among synonyms for variety.
- Prefer common words: use, start, help, before, after, get, show, and also.
- Keep technical terms that carry necessary precision. Define unfamiliar terms
  on first use.
- Define an abbreviation on first use, then use the abbreviation consistently.
- Avoid promotional words such as seamless, powerful, cutting-edge, effortless,
  and world-class.

### Verbs

- Put the actor before the action when responsibility matters.
- Keep passive voice when the actor is unknown or irrelevant: "The field is
  required" can be clearer than naming the validator.
- Express actions as verbs: "analyze the log," not "perform an analysis of the
  log."
- Prefer a simple verb to a phrasal verb: "start" instead of "spin up," when the
  two mean the same thing.
- Use simple tenses when they preserve the timing. Do not force every sentence
  into the present tense if sequence or duration matters.

### Sentences and paragraphs

- Give each instruction one main action. Keep simultaneous actions together
  only when separating them would change the procedure.
- Put a condition before its command: "If the test fails, read the log."
- Keep the article or other determiner when English requires it: "Remove the
  bolts from the panel."
- Unpack long noun clusters. "Agent task queue priority handler" can become
  "handler that sets the task-queue priority."
- Use one topic per paragraph. Split a paragraph that accumulates unrelated
  facts or more than about six sentences.
- Connect related sentences with plain conjunctions. Short sentences should not
  become a disconnected sequence of fragments.
- Treat 20 words for an instruction and 25 words for description as review
  thresholds in strict mode. Preserve a longer sentence if splitting it loses a
  fact, condition, or relationship.

### Procedures

- Use a numbered list for ordered steps.
- Start each step with an imperative verb.
- Put one action in each step unless actions happen together.
- Put a condition in the same step as its command.
- Place a warning or caution directly before the step it protects.
- Use WARNING for injury risk, CAUTION for damage risk, and NOTE for information.
  Do not hide an instruction inside a note.

## Strict controlled mode

Use these constraints only when the user requests STE or the material is a
strict procedure, safety instruction, or tightly controlled error message:

- Use simple present, simple past, simple future, infinitives, and imperatives.
- Avoid perfect tenses and stacked auxiliary verbs.
- Avoid contractions.
- Enforce one instruction per sentence.
- Review instructions over 20 words and descriptions over 25 words.
- Keep paragraphs to one topic and no more than six sentences.
- Use articles and demonstratives where applicable.
- Use American spelling if the requested standard requires it.
- Prefer "because" for cause, "can" for ability or permission, and "must" for a
  requirement. Do not change a real distinction between "may," "should," and
  "must" merely to satisfy this style guide.

Full ASD-STE100 includes an approved dictionary and judgment rules. A short
skill cannot certify compliance. Describe unverified output as "STE-inspired"
or "controlled English," not certified STE.

## Information guards

- Keep every fact, number, condition, exception, and scope qualifier.
- Preserve identifiers, commands, part numbers, units, error strings, and quoted
  safety wording exactly.
- Change the smallest span that fixes the problem.
- Do not expand a short label into a sentence merely to satisfy an article rule.
- Do not trade accuracy for a lower sentence length or simpler vocabulary.
