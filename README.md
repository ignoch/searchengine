# SearchEngine API

This search engine needs to have the appropiate keys to make requests in
Google and Bing. See the proper API documentation to get those keys.

Google: https://developers.google.com/custom-search/docs/overview
Bing: https://docs.microsoft.com/en-us/bing/search-apis/bing-web-search/overview

Once you get the keys, rename the `.env.example` to `.env` and paste it
into the file.

## Make a request

```
curl --location --request POST 'localhost:3000/api/v1/search' \
--header 'Content-Type: application/json' \
--data-raw '{
    "engine": "both",
    "text": "bible red"
}'
```

* engine: _can be google, bing or both_
* text: _text that you want to find in the engine search_

## Running test

```
bundle exec rails tests
```
