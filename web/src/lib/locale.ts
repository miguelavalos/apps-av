import { useEffect, useState } from "react";
import { appsAvLocaleChangeEvent, appsAvLocaleCookieName, appsAvLocales, type AppsAvLocale } from "../config/product-config";

export function useAppsAvLocale() {
  const [locale, setLocaleState] = useState<AppsAvLocale>(() => getAppsAvLocale());

  useEffect(() => {
    const handleLocaleChange = (event: Event) => {
      const locale = (event as CustomEvent<AppsAvLocale>).detail;
      if (appsAvLocales.includes(locale)) {
        setLocaleState(locale);
      }
    };

    window.addEventListener(appsAvLocaleChangeEvent, handleLocaleChange);
    setLocaleState(getAppsAvLocale());

    return () => window.removeEventListener(appsAvLocaleChangeEvent, handleLocaleChange);
  }, []);

  return locale;
}

export function setAppsAvLocale(locale: AppsAvLocale) {
  document.cookie = `${appsAvLocaleCookieName}=${locale}; path=/; max-age=31536000; SameSite=Lax`;
  document.documentElement.lang = locale;
  window.dispatchEvent(new CustomEvent(appsAvLocaleChangeEvent, { detail: locale }));
}

export function getAppsAvLocale() {
  if (typeof document === "undefined") {
    return "en";
  }

  const cookie = document.cookie
    .split("; ")
    .find((entry) => entry.startsWith(`${appsAvLocaleCookieName}=`))
    ?.split("=")[1];

  return appsAvLocales.includes(cookie as AppsAvLocale) ? (cookie as AppsAvLocale) : "en";
}
