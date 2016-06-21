BBH Koffer Frontend
===================

This is the frontend part of BBH Koffer. It's missing the images and fonts since
they are licensed only for use in the exhibition. Just use your imagination.
It's beautiful, trust me.

TODOs
-----

- add a Makefile
- get Elm from npm (package.json)

Build
-----

- Somehow install Elm.
- `elm make App/Main.elm --output out.js`

To update the UUIDs convert the CSV to Elm code:

	tail +2 data/koffer.csv | awk -F ';' '{ print ", { uuid = \"" $1 "\", name = \"" $2 "\", text = \"" $5 "\" }" }' >> app/Main.elm

...and replace the `db : List Thing` content. I know, we really need the Makefile.
