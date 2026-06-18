import {
  appsAvLocaleNames,
  appsAvLocales,
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
  const links = getFooterLinks(product, labels);

  return (
    <footer className={cn("border-t border-border/35 bg-background/82 px-4 py-3 text-xs text-muted-foreground backdrop-blur", className)}>
      <div className="mx-auto flex max-w-6xl flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
        <div className="flex flex-wrap items-center gap-x-3 gap-y-1">
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
        <nav className="flex flex-wrap items-center gap-x-2 gap-y-1" aria-label={labels?.language ?? "Language"}>
          {appsAvLocales.map((locale) => (
            <button
              key={locale}
              className={cn("cursor-pointer transition hover:text-foreground", locale === activeLocale ? "font-semibold text-foreground" : "")}
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

function getFooterLinks(product: AppsAvProductConfig, labels?: AvAppFooterLabels) {
  return [
    withLabel(product.links.support, labels?.support),
    withLabel(product.links.privacy, labels?.privacy),
    withLabel(product.links.terms, labels?.terms),
    withLabel(product.links.deleteAccount, labels?.deleteAccount)
  ].filter(Boolean) as AppsAvProductLink[];
}

function withLabel(link: AppsAvProductLink | undefined, label: string | undefined) {
  return link && label ? { ...link, label } : link;
}
