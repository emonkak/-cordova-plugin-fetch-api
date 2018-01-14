var exec = require('cordova/exec');

function fetch(input, init) {
    var request = typeof input === 'string' ? new Request(input, init) : input;

    return new Promise(function(resolve, reject) {
        function onSuccess(body, responseInfo) {
            var response = new Response(body, responseInfo);

            if (window.fetch.polyfill) {
                response.text = function() {
                    const decoder = new TextDecoder();
                    return Promise.resolve(decoder.decode(body));
                };
            }

            Object.defineProperty(response, "url", {
                  enumerable: true,
                  configurable: false,
                  writable: false,
                  value: responseInfo.url
            });

            resolve(response);
        }

        function onError(error) {
            reject(new Error(error.error));
        }

        request.arrayBuffer().then(function(body) {
            exec(onSuccess, onError, 'FetchAPI', 'fetch', [
                request.url,
                request.method,
                Array.from(request.headers),
                body
            ]);
        })
    });
};

module.exports = fetch;
