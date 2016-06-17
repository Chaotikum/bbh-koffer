BBH Koffer
==========

This is an IoT suitcase, built together with students from the [GGS St. Jürgen][ggs]
school and the [Buddenbrookhaus][bbh] museum in Lübeck, Germany, for the exhibition
["Fremde Heimat"][fh].

Basically we have different items in which we embedded [Estimote Beacons][es]
and a suitcase that's positioned above a Bluetooth antenna. The backend checks
whether the items are visible and sends `IN` and `OUT` events to the client
connected via [SSE][sse]. Theres another beacon in the case's lid to detect
open/close events. The client then displays the currently visible items and
presents a little text for each of them. On closing the lid it increments each
item's statistics counter and shows a little bar chart about how many other
people found this item usefull as well.

The backend is a node.js application, frontend is written in Elm.

[ggs]: http://www.ggs-stjuergen.de/home.html
[bbh]: http://buddenbrookhaus.de
[fh]: http://buddenbrookhaus.de/de/46/asid:211/ausstellungen-buddenbrookhaus.html
[es]: http://estimote.com
[sse]: https://en.wikipedia.org/wiki/Server-sent_events
