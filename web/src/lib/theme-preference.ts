export type AppsAvThemePreference = "system" | "light" | "dark";

export function normalizeAppsAvThemePreference(theme: string | null | undefined): AppsAvThemePreference {
  return theme === "light" || theme === "dark" ? theme : "system";
}

export function readAppsAvThemePreference(storageKey: string) {
  try {
    return window.localStorage?.getItem(storageKey) ?? null;
  } catch {
    return null;
  }
}

export function applyAppsAvThemePreference({
  attributeName,
  storageKey,
  theme
}: {
  attributeName: string;
  storageKey: string;
  theme: AppsAvThemePreference;
}) {
  if (theme === "system") {
    removeAppsAvThemePreference(storageKey);
    delete document.documentElement.dataset[attributeName];
    return;
  }
  writeAppsAvThemePreference(storageKey, theme);
  document.documentElement.dataset[attributeName] = theme;
}

export function writeAppsAvThemePreference(storageKey: string, theme: Exclude<AppsAvThemePreference, "system">) {
  try {
    window.localStorage?.setItem(storageKey, theme);
  } catch {
    // Theme still applies for the current page when browser storage is unavailable.
  }
}

export function removeAppsAvThemePreference(storageKey: string) {
  try {
    window.localStorage?.removeItem(storageKey);
  } catch {
    // Theme still returns to system for the current page when browser storage is unavailable.
  }
}
