# Quick Question...

Install with `gem install quickquestion`.
Set `ANTHROPIC_API_KEY` env var to your [API key](https://console.anthropic.com/account/keys).

Then ask Claude a quick question from the CLI with `qq`:

    $ qq how do I tell if Im using an rbenv ruby or the system ruby
    Run `which ruby` - if it shows a path containing `.rbenv` you're using rbenv.
    System Ruby typically shows `/usr/bin/ruby`. (Cost: $0.0007)
    $ cat question.txt | qq
    ...
    $ echo "question" | qq
    ...
    
    # or just qq alone for a prompt with readline:
    $ qq
    > rbenv command to install the lastest ruby and make it the global default
    rbenv install $(rbenv install -l | grep -v - | tail -1) &&
    rbenv global $(rbenv install -l | grep -v - | tail -1) (Cost: $0.0008)

It's most useful for these small, low-stakes practical puzzles where you can
quickly judge the results.

## Expectations

`qq` is a quick hack.
There are currently no options.

Your questions and answers are logged to `~/.config/qq/log.sqlite`
(or set [XDG_CONFIG_HOME](https://specifications.freedesktop.org/basedir-spec/latest/#variables)).

## Possible TODOs

 * Handle ctrl-c without traceback.
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

    gem push quickquestion-0.0.0.gem
