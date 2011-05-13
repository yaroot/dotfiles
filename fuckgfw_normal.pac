
var gfwlist = [
                    'google.com',
                    'googlecode.com',
                    '1e100.net',
                    'gmail.com',
                    'picasaweb.com',
                    'ggpht.com',
                    'youtube.com',
                    'ytimg.com',
                    'appspot.com',
                    'blogger.com',
                    'blogspot.com',
                    'wikipedia.org',
                    'wikileak.org',

                    'freebsd.com',
                    'python.org',

                    'thepiratebay.com',

                    'bullogger.com',
                    'feedburner.com',

                    'wordpress.com',
                    'twitter.com',
                    'posterous.com',
                    'tumblr.com',
                    'friendfeed.com',
                    'facebook.com',
                    'fbcdn.com',
                    'dabr.co.uk',
                    'chatterous.com',
                    'twitpic.com',
                    'yfrog.com',
                    'moby.to',

                    'box.com',
                    'dropbox.com',
                    'last.fm',
                    'pandora.com',
                    'vimeo.com',
                    'videopress.com',
                    'status.net',

                    'bit.ly',
                    'ff.im',
                    'j.mp',
                    'wp.me',
                    'post.ly'
            ];


var DEFAULT = "DIRECT";
//var PROXY = "PROXY localhost:8123";
var PROXY = "SOCKS localhost:7070";

function FindProxyForURL(url, host){
    if(url){
        for(var i=0; i<gfwlist.length; i++){
            if(url.match(gfwlist[i])){
                return PROXY;
            }
        }
    }
    return DEFAULT;
}
