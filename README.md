# mpv-sub-skip 

This is a very simple script I hacked together in a few minutes. Basically, it automatically sets the subtitles to full instead of "Signs&Songs".

## The problem
Some anime have multiple subtitles, the first being "Signs&Songs". This sub only has the opening sequence and some text in anime translated, not the actual dialogue. Second one is usually the full version which covers everything. The problem begins when the encoders set both of these as English. mpv automatically picks the first one, the incomplete one, instead of the full one.

## What do I do?
I wrote this simple script that on start automatically checks the subtitles from first to last. If the title has "signs" or "songs" in it, it'll skip that track and move on to the next one. If the title does not contain "signs" or "songs", it'll set it as the subtitle.

## How do I add more skip words?
Simply edit the `keywordsArray`. If the title contains those words, it'll automatically get skipped.

## I want to disable the on-screen messages.
Change the `can_log` variable from `true` to `false`.
