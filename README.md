# Glass OpenClaw — free sideload (no paid Apple / no TestFlight)

Official until a paid Apple Developer account exists.

## Cloud unsigned build

Repo (public): https://github.com/reityran-svg/glass-openclaw  

**IPA / unsigned build:** GitHub → **Actions** → latest **build-ipa** run → **Artifacts** (`GlassOpenClaw-unsigned`). Field MSI can open this URL without a collaborator invite. If the artifact is empty, `xcodebuild` failed; use `/glass/dat` until Sideloadly has a signed `.app`.

Download **Actions → latest build-ipa → Artifacts → glass-openclaw-unsigned**.  
That IPA is **unsigned**. Sideloadly must re-sign it with a **free Apple ID** (7-day cert). Do not install it raw.

## Sideloadly on desktop-ej8jl1o (Windows, free Apple ID)

1. Install Sideloadly: https://sideloadly.io
2. Plug in iphone181 **or** use Wi-Fi sync; same Apple ID you use on the phone.
3. IPA = Actions artifact (or a Mac-signed build).
4. Sideloadly re-signs with the **free** Apple ID. Apps last **7 days**, then resign.
5. Trust the developer on the iPhone: Settings → General → VPN & Device Management.
6. Meta AI → App connections → Developer mode apps → this app.
7. Keep Tailscale on. The app POSTs to `https://desktop-ej8jl1o.tailfdcf6f.ts.net/hooks/glass`.

AltStore/AltServer is the Mac-oriented equivalent (also 7-day free cert).

## Temporary

https://desktop-ej8jl1o.tailfdcf6f.ts.net/glass/dat — Start listen. Same hook. Retire only after the sideloaded app stays running.
