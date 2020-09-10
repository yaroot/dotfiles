# frontpage

`https://tabliss.io/`

# addons

```
cat extensions.json | jq -r '.addons[].defaultLocale.name'
cat addons.json | jq -r '.addons[].name'
```


- uBlock Origin
- Firefox Multi-Account Containers
- Cookie AutoDelete
- Bitwarden - Free Password Manager
- Tampermonkey
- uMatrix
- User-Agent Switcher
- Video Speed Controller
- Reader
- Container Tabs Sidebar
- Bypass Paywalls Clean


# about:config

content of `/usr/lib/firefox/defaults/pref/prefs.js`

```
pref("beacon.enabled", false);
pref("browser.cache.disk.enable", false);
pref("browser.cache.memory.capacity", 102400);
pref("browser.cache.memory.enable", true);
pref("browser.ctrlTab.recentlyUsedOrder", false);
pref("browser.urlbar.trimURLs", false);
pref("browser.zoom.full", true);
pref("browser.zoom.siteSpecific", true);
pref("browser.zoom.updateBackgroundTabs", false);
pref("network.IDN_show_punycode", true);
pref("privacy.donottrackheader.enabled", true);
pref("privacy.firstparty.isolate", true);
pref("privacy.resistFingerprinting", true);
pref("privacy.trackingprotection.enabled", true);
pref("security.dialog_enable_delay", 0);
pref("services.sync.prefs.sync.browser.ctrlTab.recentlyUsedOrder", false);
```

