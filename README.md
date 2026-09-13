# noodles/homebrew-tap

Homebrew formulae for tools by [Rich Hall](https://github.com/noodles).

```sh
brew tap noodles/tap
brew trust noodles/tap
brew install projectboss
```

Homebrew requires trusting a third-party tap before it will load anything from
it. That applies to every tap, not just this one.

| Formula | What it is |
|---|---|
| [`projectboss`](Formula/projectboss.rb) | [ProjectBoss](https://github.com/noodles/ProjectBoss): keeps an index of your projects and tells you which ones have gone stale. Installs the command as `pb` |
