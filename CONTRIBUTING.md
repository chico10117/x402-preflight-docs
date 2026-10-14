# Contributing

Thanks for reading this closely enough to want to fix something.

## What belongs here

- Public, verifiable documentation: what x402 does, how to configure it, how to check an endpoint,
  and what a check can and cannot establish.
- Corrections. If a claim here is wrong or outdated, that is the most valuable contribution.

## What does not belong here

- Service source code, payment implementation details, credentials, deployment or infrastructure
  configuration. The service repository is private and stays that way.
- Marketing copy. State the behaviour, the command to reproduce it, and the limitation.

## How to propose a change

1. Open an issue describing the problem, or go straight to a pull request for small fixes.
2. One change per pull request, with the reason in the description.
3. For a behavioural claim, include the command and its real output. "It should return 402" is not
   evidence; the response is.

## Style

- State what is proven and what is not. If a check proves only that an endpoint *asks* for payment,
  say so.
- Prefer the observable contract over prose: headers, status codes, payloads.
- Plain English, short sentences, no marketing adjectives.
