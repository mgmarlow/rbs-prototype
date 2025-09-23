# Up and running with RBS in Rails

RBS ships with Ruby, but actually type-checking the app requires
[steep](https://github.com/soutaro/steep), a third-party gem.

- RBS files live in `sig/`
- Only controllers, models, and services are currently typechecked

## Initial setup

1. `bundle add steep`
1. `bundle binstubs steep`
1. `bin/steep init`
1. Create `Steepfile`
1. Run `bin/steep check` to typecheck

Example `Steepfile`:

```rb
target :app do
  signature "sig"

  check "app"
  # Alternatively
  # check "app/controllers/**/*.rb"
  # check "app/models/**/*.rb"
  # check "app/services/**/*.rb"
end
```

Note that `library` attempts to load RBS files for gems. Not all third-party
libraries ship RBS files, so the [RBS
collection](https://github.com/soutaro/steep/blob/master/guides/src/gem-rbs-collection/gem-rbs-collection.md)
tool fills in missing files with community-maintained signaturesß.

1. `rbs collection init`
1. `rbs collection install`

## Tools

Auto-generate first-pass RBS definitions w/ `rbs prototype`:

```
% rbs prototype rb app/models/book.rb
class Book < ApplicationRecord
end
```

(not very useful when the majority of implementation is ActiveRecord!)

Better results when used with PORO service code:

```
% rbs prototype rb app/services/foo_service.rb
class FooService
  def run: () -> untyped
end
```

Generally I've found Claude to do a better job generating RBS files for existing
code.

## Error messaging

Here's an example error, `Book` does not define a method called
`use_undefined_method`:

```
% bin/steep check
# Type checking files:

...F...

app/services/foo_service.rb:4:9: [error] Type `(::Book | nil)` does not have method `use_undefined_method`
│ Diagnostic ID: Ruby::NoMethod
│
└     book.use_undefined_method
           ~~~~~~~~~~~~~~~~~~~~

Detected 2 problems from 1 file
```

## Other tools attempted

[rbs_rails](https://github.com/pocke/rbs_rails), unofficial Rails signature
generator:

1. `bundle add rbs_rails`
1. `bin/rails g rbs_rails:install`
1. `bin/rails rbs_rails:all`

This gem is very verbose and didn't generate _everything_ out-of-the-box. There
have been a lot of upstream changes merged that haven't yet been released, so
perhaps the quality of this gem will improve within a month or so (based on
Github Issue discussions). That said, it does seem very useful to auto-generate
ActiveRecord models since they have such a huge number of built-in methods that
we'd otherwise need to implement one-by-one.

## Future work

- Explore [typeprof](https://github.com/ruby/typeprof) and LSP integration

## Additional resources

- https://rubykaigi.org/2025/presentations/sinsoku_listy.html
- https://rubykaigi.org/2025/presentations/mametter.html
- https://rubykaigi.org/2023/presentations/p_ck_.html
