# Glass OpenClaw — free sideload (no paid Apple / no TestFlight)

Official until a paid Apple Developer account exists.

## Cloud unsigned build

Repo: https://github.com/reityran-svg/glass-openclaw  
Actions → **build-ipa** → artifact **GlassOpenClaw-unsigned**.

`xcodebuild` may still fail on DAT SPM; if the artifact is empty, use `/glass/dat` until a Mac signs the project.

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
