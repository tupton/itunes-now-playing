# iTunes Now Playing

A simple Perl script that grabs the currently-playing track from iTunes and
displays the artist and track name in plain text.

Written by [Thomas Upton][tu]

[tu]: http://www.thomasupton.com/

This code uses a function conceived by John Gruber that is used to tell if the
iTunes application is currently running. More information can be found on [Daring
Fireball][df].

[df]: http://daringfireball.net/2006/10/how_to_tell_if_an_app_is_running

This code is licensed under a [BY-NC-SA Creative Commons][cc] license.

[cc]: http://creativecommons.org/licenses/by-nc-sa/3.0/us/

Make the script executable before using it.

    $ chmod +x now-playing.pl

Usage:

    $ ./now-playing.pl

When using this script on OS X, it may be useful to pipe this command through
iconv for Unicode character support.

    $ ./now-playing.pl | iconv -f utf-8 -t ucs-2-internal

