

var DEFAULT = "DIRECT";
//var PROXY = "PROXY localhost:8123";
var PROXY = "SOCKS localhost:7070";

function FindProxyForURL(url, host){
    if(host.match("localhost") ||
       host.match("192.168") ||
       host.match("127.0"))
    {
        return DEFAULT;
    } else {
        return PROXY;
    }
}

