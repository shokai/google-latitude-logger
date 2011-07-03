Google Latitude Logger
======================
Store your Location Logs to MongoDB


Setup Latitude Badge API
------------------------

enable your Google Latitude Badge and Get USER-ID from embed code.
[https://www.google.com/latitude/b/0/apps](https://www.google.com/latitude/b/0/apps)


Config App
----------

    % cp sample.config.yaml config.yaml

edit config.yaml.


Install Dependencies
--------------------

    % brew install mongodb # for MacOSX
    % gem install json mongo bson bson_ext


Run Logger
----------

    % ruby -Ku latitude-logger.rb
