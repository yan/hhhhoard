Hhhhoard
==============

Hhhhoard is a tiny program to download images from ffffound(.com) via Google
Reader. Hhhhoard grabs a list of all your unread posts in the ffffound feed,
downloads the original image, then marks it as 'read' in Google Reader.

## Prerequisites
I generally check Ffffound images via a subscription in Google Reader. I go
through the feed and mark images I'd like to save as unread (shortcut 'm').
Once you have items you like marked as unread, running this tool should resolve
the original images, download them, then mark your ffffound entries as unread
as the list is processed.

If you kill the process in the middle, nothing will be lost. Run it again to
continue where you left off.

## Usage
1. Before anything, update the Hhhhoard/Creds.hs file with your own credentials.
You should probably create a new 2-factor password for this in your Google
account preferences.

2. Run inside the project dir:

	mkdir imgs

3. Compile the sources:

    cabal configure
    cabal build

4. Run:

    ./dist/build/hhhhoard/hhhhoard

and hhhhoard will download all the images into the `imgs/` directory in $PWD.

All images for which the original source was not found will remain marked
as 'unread' and you should get them manually.


## TODO
1. Prepare a correct Cabal description + dependencies
2. Come up with a better way to pass credentials to the app or use OAuth.
3. Make the target dir configurable.
4. Clean up the src
