import { useEffect, useState } from "react";
import {
  appsAvLocaleCookieName,
  appsAvLocaleNames,
  appsAvLocales,
  type AppsAvLocale,
  type AppsAvProductConfig,
  type AppsAvProductLink
} from "../config/product-config";
import { cn } from "../lib/cn";

export interface AvAppFooterProps {
  className?: string;
  product: AppsAvProductConfig;
}

export function AvAppFooter({ className, product }: AvAppFooterProps) {
  const [activeLocale, setActiveLocale] = useState<AppsAvLocale>("en");
  const links = getFooterLinks(product);

  useEffect(() => {
    const savedLocale = readLocaleCookie();
    if (savedLocale) {
      setActiveLocale(savedLocale);
      document.documentElement.lang = savedLocale;
    }
  }, []);

  return (
    <footer className={cn("border-t border-border/35 bg-background/82 px-4 py-3 text-xs text-muted-foreground backdrop-blur", className)}>
      <div className="mx-auto flex max-w-6xl flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
        <div className="flex flex-wrap items-center gap-x-3 gap-y-1">
          <span>© {new Date().getFullYear()} Avalsyst</span>
          {links.map((link) => (
            <a
              key={link.href}
              className="transition hover:text-foreground"
              href={link.href}
              rel={link.external ? "noreferrer" : undefined}
              target={link.external ? "_blank" : undefined}
            >
              {link.label}
            </a>
          ))}
        </div>
        <nav className="flex flex-wrap items-center gap-x-2 gap-y-1" aria-label="Language">
          {appsAvLocales.map((locale) => (
            <button
              key={locale}
              className={cn("transition hover:text-foreground", locale === activeLocale ? "font-semibold text-foreground" : "")}
              type="button"
              onClick={() => selectLocale(locale, setActiveLocale)}
            >
              {appsAvLocaleNames[locale]}
            </button>
          ))}
        </nav>
      </div>
    </footer>
  );
}

function getFooterLinks(product: AppsAvProductConfig) {
  return [product.links.support, product.links.privacy, product.links.terms, product.links.deleteAccount].filter(Boolean) as AppsAvProductLink[];
}

function selectLocale(locale: AppsAvLocale, setActiveLocale: (locale: AppsAvLocale) => void) {
  document.cookie = `${appsAvLocaleCookieName}=${locale}; path=/; max-age=31536000; SameSite=Lax`;
  document.documentElement.lang = locale;
  setActiveLocale(locale);
}

function readLocaleCookie() {
  const cookie = document.cookie
    .split("; ")
    .find((entry) => entry.startsWith(`${appsAvLocaleCookieName}=`))
    ?.split("=")[1];

  return appsAvLocales.includes(cookie as AppsAvLocale) ? (cookie as AppsAvLocale) : undefined;
}
