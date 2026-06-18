import {
  appsAvLocaleNames,
  appsAvLocales,
  type AppsAvLocale,
  type AppsAvProductConfig,
  type AppsAvProductLink
} from "../config/product-config";
import { cn } from "../lib/cn";
import { setAppsAvLocale, useAppsAvLocale } from "../lib/locale";

export interface AvAppFooterLabels {
  deleteAccount?: string;
  language?: string;
  privacy?: string;
  support?: string;
  terms?: string;
}

export interface AvAppFooterProps {
  className?: string;
  labels?: AvAppFooterLabels;
  product: AppsAvProductConfig;
}

export function AvAppFooter({ className, labels, product }: AvAppFooterProps) {
  const activeLocale = useAppsAvLocale();
  const links = getFooterLinks(product, labels, activeLocale);

  return (
    <footer className={cn("border-t border-border/35 bg-background/82 px-4 py-3 text-xs text-muted-foreground backdrop-blur", className)}>
      <div className="mx-auto flex max-w-6xl flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
        <div className="flex flex-wrap items-center gap-x-3 gap-y-1">
          {links.map((link) => (
            <a
              key={link.href}
              className="rounded-sm outline-none transition hover:text-foreground focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-ring focus-visible:ring-[3px] focus-visible:ring-ring/50"
              href={link.href}
              rel={link.external ? "noreferrer" : undefined}
              target={link.external ? "_blank" : undefined}
            >
              {link.label}
            </a>
          ))}
        </div>
        <nav className="flex flex-wrap items-center gap-x-2 gap-y-1" aria-label={labels?.language ?? "Language"}>
          {appsAvLocales.map((locale) => (
            <button
              key={locale}
              className={cn("cursor-pointer rounded-sm outline-none transition hover:text-foreground focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-ring focus-visible:ring-[3px] focus-visible:ring-ring/50", locale === activeLocale ? "font-semibold text-foreground" : "")}
              type="button"
              onClick={() => setAppsAvLocale(locale)}
            >
              {appsAvLocaleNames[locale]}
            </button>
          ))}
        </nav>
      </div>
    </footer>
  );
}

function getFooterLinks(product: AppsAvProductConfig, labels: AvAppFooterLabels | undefined, locale: AppsAvLocale) {
  return [
    withLocalizedLink(product.links.support, labels?.support, locale),
    withLocalizedLink(product.links.privacy, labels?.privacy, locale),
    withLocalizedLink(product.links.terms, labels?.terms, locale),
    withLocalizedLink(product.links.deleteAccount, labels?.deleteAccount, locale)
  ].filter(Boolean) as AppsAvProductLink[];
}

function withLocalizedLink(link: AppsAvProductLink | undefined, label: string | undefined, locale: AppsAvLocale) {
  if (!link) {
    return undefined;
  }

  return {
    ...link,
    href: localizeOwnedHref(link.href, locale),
    label: label ?? link.label
  };
}

function localizeOwnedHref(href: string, locale: AppsAvLocale) {
  if (locale === "en") {
    return stripLocalePrefix(href);
  }

  try {
    const url = new URL(href);
    if (!isOwnedHost(url.hostname)) {
      return href;
    }

    url.pathname = localizePath(url.pathname, locale);
    return url.toString().replace(/\/$/, "");
  } catch {
    return href;
  }
}

function localizePath(pathname: string, locale: AppsAvLocale) {
  const normalizedPath = stripLocalePrefix(pathname || "/");

  return `/${locale}${normalizedPath === "/" ? "" : normalizedPath}`;
}

function stripLocalePrefix(value: string) {
  return value.replace(/^\/(es|fr|de|ca)(?=\/|$)/, "") || "/";
}

function isOwnedHost(hostname: string) {
  return hostname === "avalsys.com" || hostname.endsWith(".avalsys.com");
}
