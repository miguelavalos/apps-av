import { createContext, useContext, useEffect, useState } from "react";
import { appsAvLocaleChangeEvent, appsAvLocaleCookieName, appsAvLocales, type AppsAvLocale } from "../config/product-config";

export const AppsAvLocaleContext = createContext<AppsAvLocale>("en");

export function useAppsAvLocale() {
  return useContext(AppsAvLocaleContext);
}

export function useManagedAppsAvLocale(
  initialLocale: AppsAvLocale = "en",
  supportedLocales: readonly AppsAvLocale[] = appsAvLocales
) {
  const [locale, setLocaleState] = useState<AppsAvLocale>(initialLocale);

  useEffect(() => {
    const handleLocaleChange = (event: Event) => {
      const locale = (event as CustomEvent<AppsAvLocale>).detail;
      if (supportedLocales.includes(locale)) {
        setLocaleState(locale);
      }
    };

    window.addEventListener(appsAvLocaleChangeEvent, handleLocaleChange);
    const requestedLocale = getAppsAvLocale(initialLocale, supportedLocales);
    const locale = supportedLocales.includes(requestedLocale)
      ? requestedLocale
      : supportedLocales[0] ?? initialLocale;
    applyAppsAvLocale(locale);
    setLocaleState(locale);

    return () => window.removeEventListener(appsAvLocaleChangeEvent, handleLocaleChange);
  }, [initialLocale, supportedLocales]);

  return locale;
}

export function setAppsAvLocale(locale: AppsAvLocale) {
  applyAppsAvLocale(locale);
  window.dispatchEvent(new CustomEvent(appsAvLocaleChangeEvent, { detail: locale }));
}

function applyAppsAvLocale(locale: AppsAvLocale) {
  document.cookie = `${appsAvLocaleCookieName}=${locale}; path=/; max-age=31536000; SameSite=Lax`;
  document.documentElement.lang = locale;
}

export function getAppsAvLocale(
  fallbackLocale: AppsAvLocale = "en",
  supportedLocales: readonly AppsAvLocale[] = appsAvLocales
) {
  if (typeof document === "undefined") {
    return fallbackLocale;
  }

  const requestedLocale = getRequestedLocale();
  if (requestedLocale) return requestedLocale;

  const cookie = document.cookie
    .split("; ")
    .find((entry) => entry.startsWith(`${appsAvLocaleCookieName}=`))
    ?.split("=")[1];

  if (supportedLocales.includes(cookie as AppsAvLocale)) {
    return cookie as AppsAvLocale;
  }

  const preferredLanguages = typeof navigator === "undefined"
    ? []
    : navigator.languages?.length
      ? navigator.languages
      : navigator.language
        ? [navigator.language]
        : [];
  return resolveInitialAppsAvLocale(preferredLanguages, supportedLocales, fallbackLocale);
}

export function resolveInitialAppsAvLocale(
  preferredLanguages: readonly string[],
  supportedLocales: readonly AppsAvLocale[] = appsAvLocales,
  fallbackLocale: AppsAvLocale = "en"
): AppsAvLocale {
  const primaryLanguage = normalizeLanguageCode(preferredLanguages[0]);
  if (primaryLanguage && supportedLocales.includes(primaryLanguage as AppsAvLocale)) {
    return primaryLanguage as AppsAvLocale;
  }

  return supportedLocales.includes(fallbackLocale)
    ? fallbackLocale
    : supportedLocales[0] ?? "en";
}

export function getAppsAvLocaleFromSearch(search: string | undefined) {
  if (!search) return "en";
  const locale = new URLSearchParams(search).get("lang");
  return appsAvLocales.includes(locale as AppsAvLocale) ? (locale as AppsAvLocale) : "en";
}

function getRequestedLocale() {
  if (typeof window === "undefined") {
    return undefined;
  }

  const locale = new URLSearchParams(window.location.search).get("lang");
  return appsAvLocales.includes(locale as AppsAvLocale) ? (locale as AppsAvLocale) : undefined;
}

function normalizeLanguageCode(rawValue: string | undefined) {
  const primarySubtag = rawValue?.trim().replaceAll("_", "-").split("-", 1)[0]?.toLowerCase();
  return primarySubtag && /^[a-z]+$/.test(primarySubtag) ? primarySubtag : undefined;
}
