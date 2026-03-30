const STORAGE_KEY = "theme_preference"
const VALID_PREFERENCES = new Set(["light", "dark", "system"])
const DARK_THEME_COLOR = "#17110b"
const LIGHT_THEME_COLOR = "#fff8f3"

const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)")

const readPreference = () => {
  try {
    return window.localStorage.getItem(STORAGE_KEY)
  } catch (_error) {
    return null
  }
}

const storedPreference = () => {
  const value = readPreference()
  return VALID_PREFERENCES.has(value) ? value : "system"
}

const resolveTheme = (preference) => {
  if (preference === "light" || preference === "dark") return preference
  return mediaQuery.matches ? "dark" : "light"
}

const syncThemeControls = (preference) => {
  document.querySelectorAll("[data-theme-select]").forEach((control) => {
    control.value = preference
  })
}

const applyTheme = (preference = storedPreference()) => {
  const resolvedTheme = resolveTheme(preference)
  const html = document.documentElement

  html.classList.remove("light", "dark")
  html.classList.add(resolvedTheme)
  html.dataset.themePreference = preference
  html.style.colorScheme = resolvedTheme

  const themeColorMeta = document.querySelector('meta[name="theme-color"]')
  if (themeColorMeta) {
    themeColorMeta.setAttribute("content", resolvedTheme === "dark" ? DARK_THEME_COLOR : LIGHT_THEME_COLOR)
  }

  syncThemeControls(preference)
}

const persistThemePreference = (preference) => {
  try {
    window.localStorage.setItem(STORAGE_KEY, preference)
  } catch (_error) {
    // Ignore storage failures and keep the preference in the current document only.
  }
}

const handlePreferenceChange = (event) => {
  const control = event.target.closest("[data-theme-select]")
  if (!control) return

  const preference = VALID_PREFERENCES.has(control.value) ? control.value : "system"
  persistThemePreference(preference)
  applyTheme(preference)
}

const handleSystemChange = () => {
  if (storedPreference() === "system") applyTheme("system")
}

document.addEventListener("change", handlePreferenceChange)
document.addEventListener("turbo:load", () => applyTheme())
window.addEventListener("pageshow", () => applyTheme())

if (typeof mediaQuery.addEventListener === "function") {
  mediaQuery.addEventListener("change", handleSystemChange)
} else {
  mediaQuery.addListener(handleSystemChange)
}

export { applyTheme }
