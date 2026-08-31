# Glass OpenClaw (DAT iPhone → TestFlight)

Native iOS companion for Ray-Ban Meta. **Expo EAS cannot compile Meta DAT.** Cloud Mac = GitHub Actions `macos-latest`.

Until this IPA is on TestFlight, `/glass/dat` is a **temporary** stand-in.

## Pipe

Glasses BT mic/camera → this app (DAT + on-device STT) → `POST https://desktop-ej8jl1o.tailfdcf6f.ts.net/hooks/glass` (`hook:glass`) → Grok on PC → poll `/glass/inbox/{id}` → speak on glasses BT. Muse Spark **cloud** voice = Meta AI speaking `/glass/last-continue`.

## Cloud IPA

1. Put this folder in a GitHub repo (or the `DAT-iPhone` path of OpenClaw glass-bridge).
2. Apple Developer + App Store Connect app `com.tyran.glassopenclaw`.
3. GitHub secrets (do not paste in chat):
   - `DEVELOPMENT_TEAM`
   - `APP_STORE_CONNECT_KEY_ID`
   - `APP_STORE_CONNECT_ISSUER_ID`
   - `APP_STORE_CONNECT_API_KEY` (p8, base64)
4. Actions → **build-ipa** → Run workflow.
5. Add iphone181 as TestFlight tester. Install from TestFlight (no public link until the first build processes).

Local Mac: `brew install xcodegen && xcodegen generate && open GlassOpenClaw.xcodeproj`

Developer Mode on glasses; this app under Meta AI → App connections → Developer mode apps.

## Secrets

Gateway tokens stay on the PC (`openclaw.json` / secrets store). This app only talks HTTPS to the Tailscale host.
