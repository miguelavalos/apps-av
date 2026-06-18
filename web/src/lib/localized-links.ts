import type { AppsAvLocale } from "../config/product-config";

export function appendAppsAvLocaleToUrl(url: string, locale: AppsAvLocale) {
  try {
    const parsed = new URL(url);
    parsed.searchParams.set("lang", locale);
    return parsed.toString();
  } catch {
    const [path = "", hash = ""] = url.split("#", 2);
    const separator = path.includes("?") ? "&" : "?";
    return `${path}${separator}lang=${encodeURIComponent(locale)}${hash ? `#${hash}` : ""}`;
  }
}

export function appsAvLocalizedPath(path: string, locale: AppsAvLocale) {
  return appendAppsAvLocaleToUrl(path, locale);
}
