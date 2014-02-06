# Mp3Huntr

Application server to download videos and extract mp3 sound files.

## OS

Ubuntu or Debian

## Dependencies

apt-get install ffmpeg youtube-dl nicovideo-dl libavcodec-extra-53

* ffmpeg
* youtube-dl
* nicovideo-dl
* libavcodec-extra-53

## Run

1. cabal update
2. cabal configure
3. cabal build
4. cp app.conf.example app.conf
5. (configure app.conf for your environment)
6. cabal run app.conf

## Test

1. cabal update
2. cabal configure --enable-tests
3. cabal build
4. cabal test

