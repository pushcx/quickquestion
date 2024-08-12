## qq

> Quick question...

Ask LLMs quick questions from the CLI with `qq`:

    $ qq how do I tell if I'm using an rbenv ruby or the system ruby
    $ cat question | qq
    
    # or just qq alone for a prompt with readline:
    $ qq
    > is rbenv or chruby more reliable?

Set `ANTHROPIC_API_KEY` env var.

Future feature:

Use `qc` to have a quick conversation, which picks up from the last `qq` if it
happened in the last 15m.

(This uses the logs in `~/.config/qq/logs`.)


## Development

    # run local
    ruby -Ilib bin/qq

    # irb with gem loaded
    irb -Ilib -rqq


# Release

    # rm old gems
    rm *.gem

    # set version in qq.gemspec

    # to make the .gem
    gem build


## Local use

    # after build
    gem install ./qq-<tab>

