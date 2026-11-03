# Project: simhash

Gem implementing Moses Charikar's simhashes, forked from `bookmate/simhash`.

# Ruby Environment

This project uses Ruby 4.0.6. However, note that Ruby 3.3 (currently 3.3.12) is LTS until the beginning of 2027, so
Ruby 3.3 and 3.4 should still be supported.

Developers use either RVM or rbenv — detect which is available and set up accordingly.

Before running any Ruby, bundle, rake, or rspec commands, always prefix with the appropriate setup:

**RVM** (if `~/.rvm/scripts/rvm` exists):
```
source ~/.rvm/scripts/rvm && rvm use ruby-4.0.6@simhash &&
```

**rbenv** (if `rbenv` is on PATH): no prefix needed — rbenv activates automatically via `.ruby-version`. Just run commands directly.

Examples (shown with RVM prefix — omit the prefix for rbenv):
- `source ~/.rvm/scripts/rvm && rvm use ruby-4.0.6@simhash && bundle exec rspec`
- `source ~/.rvm/scripts/rvm && rvm use ruby-4.0.6@simhash && bundle install`
- `source ~/.rvm/scripts/rvm && rvm use ruby-4.0.6@simhash && bundle exec rake shell`

## Conventions

- Follow TDD: write specs first, verify they fail for the expected reason, then write the implementation to make them pass. Don't batch spec + implementation together and run once.
