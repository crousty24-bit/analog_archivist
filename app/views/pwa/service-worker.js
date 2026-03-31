self.addEventListener("install", (event) => {
  event.waitUntil(self.skipWaiting())
})

self.addEventListener("activate", (event) => {
  event.waitUntil(self.clients.claim())
})

// This base worker intentionally does not cache application requests yet.
// It exists to support installation and to provide a safe place for future,
// explicit offline behavior.
