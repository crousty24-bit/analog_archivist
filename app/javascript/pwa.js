const SERVICE_WORKER_PATH = "/service-worker.js"

let serviceWorkerRegistration

function registerServiceWorker() {
  if (!("serviceWorker" in navigator)) return
  if (serviceWorkerRegistration) return

  window.addEventListener("load", async () => {
    try {
      serviceWorkerRegistration = await navigator.serviceWorker.register(SERVICE_WORKER_PATH)
    } catch (_error) {
      serviceWorkerRegistration = null
    }
  }, { once: true })
}

registerServiceWorker()
