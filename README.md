# Quick Question...

Ask Claude a quick question from the CLI with `qq`:

    $ qq how do I tell if I'm using an rbenv ruby or the system ruby
    $ cat question.txt | qq
    $ echo "question" | qq
    
    # or just qq alone for a prompt with readline:
    $ qq
    > is rbenv or chruby more reliable?

Set `ANTHROPIC_API_KEY` env var to your [API key](https://console.anthropic.com/account/keys).

## Expectations

`qq` is a quick hack.
There are currently no options.

Your questions and answers are logged to `~/.config/qq/log.sqlite`
(or set [XDG_CCONFIG_HOME](https://specifications.freedesktop.org/basedir-spec/latest/#variables)).

## Possible TODOs

 * Handle ctrl-c without traceback
 * Prompt customization.
 * Use `qc` to have a quick conversation (or `quick continue`), which picks up from the last `qq` if it happened in the last 15m.
   (This uses the logs in `~/.config/qq/log.sqlite`.)
 * Prompt for a response in tags. Use `stop_sequences` to end abruptly.
 * https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching

## Development

    # run local
    ruby -Ilib bin/qq

    # irb with gem loaded
    irb -Ilib -rqq

## Local use

    # after build
    gem install ./qq-<tab>

# Release

    # rm old gems
    rm *.gem

    # set version in qq.gemspec

    # to make the .gem
    gem build

