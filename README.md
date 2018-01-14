# cordova-plugin-fetch-api

Cordova plugin that provides the [Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API#Fetch_Interfaces) compatible fetch() function.

This function is useful when doing cross-origin request on WKWebview of iOS.

# Usage

```javascript
cordova.plugins.fetch('http://example.com')
    .then(function(response) {
        return response.text();
    })
    .then(function(htmlString) {
        console.log(htmlString);
    });
```

# Limitations

The following request options are not supported.

- `cache`
- `credentials`
- `integrity`
- `keepalive`
- `mode`
- `redirect`
- `referrer`
- `referrerPolicy`
- `window`
