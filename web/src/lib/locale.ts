import { useEffect, useState } from "react";
import { appsAvLocaleChangeEvent, appsAvLocaleCookieName, appsAvLocales, type AppsAvLocale } from "../config/product-config";

export function useAppsAvLocale() {
  const [locale, setLocaleState] = useState<AppsAvLocale>("en");

  useEffect(() => {
    const handleLocaleChange = (event: Event) => {
      const locale = (event as CustomEvent<AppsAvLocale>).detail;
      if (appsAvLocales.includes(locale)) {
        setLocaleState(locale);
      }
    };

    window.addEventListener(appsAvLocaleChangeEvent, handleLocaleChange);
    const locale = getAppsAvLocale();
    applyAppsAvLocale(locale);
    setLocaleState(locale);

    return () => window.removeEventListener(appsAvLocaleChangeEvent, handleLocaleChange);
  }, []);

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

export function getAppsAvLocale() {
  if (typeof document === "undefined") {
    return "en";
  }

  const requestedLocale = getRequestedLocale();
  if (requestedLocale) return requestedLocale;

  const cookie = document.cookie
    .split("; ")
    .find((entry) => entry.startsWith(`${appsAvLocaleCookieName}=`))
    ?.split("=")[1];

  return appsAvLocales.includes(cookie as AppsAvLocale) ? (cookie as AppsAvLocale) : "en";
}

function getRequestedLocale() {
  if (typeof window === "undefined") {
    return undefined;
  }

  const locale = new URLSearchParams(window.location.search).get("lang");
  return appsAvLocales.includes(locale as AppsAvLocale) ? (locale as AppsAvLocale) : undefined;
}
