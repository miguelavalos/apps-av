import type { ReactNode } from "react";
import type { AppsAvProductConfig, AppsAvProductLink } from "../config/product-config";
import { AvAppFooter, type AvAppFooterLabels } from "./av-app-footer";
import { MobileDrawerNav } from "./mobile-drawer-nav";

export interface AppShellProps {
  product: AppsAvProductConfig;
  navLinks: AppsAvProductLink[];
  children: ReactNode;
  currentPath?: string;
  footerLabels?: AvAppFooterLabels;
  labels?: AppShellLabels;
}

export interface AppShellLabels {
  assistant?: string;
  home?: string;
  mobileNavigation?: string;
  openNavigation?: string;
  primaryNavigation?: string;
}

export function AppShell({ product, navLinks, children, currentPath, footerLabels, labels }: AppShellProps) {
  const homeHref = navLinks[0]?.href ?? "/";
  const assistantLabel = labels?.assistant ?? product.assistant?.label;

  return (
    <div className="min-h-screen bg-background text-foreground">
      <header className="sticky top-0 z-10 border-b bg-background/88 backdrop-blur">
        <div className="mx-auto flex h-16 max-w-6xl items-center justify-between px-4">
          <a className="flex min-w-0 items-center gap-3" href={homeHref} aria-label={labels?.home ?? `${product.name} home`}>
            {product.logoSrc ? (
              <img alt="" className="h-9 w-auto max-w-36 object-contain" src={product.logoSrc} />
            ) : (
              <>
                {product.iconSrc ? <img alt="" className="size-8 rounded-md" src={product.iconSrc} /> : null}
                <span className="text-sm font-semibold">{product.name}</span>
              </>
            )}
          </a>
          <nav className="hidden items-center gap-1 md:flex" aria-label={labels?.primaryNavigation ?? "Primary navigation"}>
            {navLinks.map((link) => (
              <a
                key={link.href}
                aria-current={isActiveAppShellLink(link.href, currentPath) ? "page" : undefined}
                className={isActiveAppShellLink(link.href, currentPath) ? "rounded-full bg-muted px-3 py-2 text-sm font-semibold text-foreground" : "rounded-full px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted hover:text-foreground"}
                href={link.href}
              >
                {link.label}
              </a>
            ))}
          </nav>
          <div className="flex items-center gap-3">
            {product.assistant ? (
              <a
                aria-current={isActiveAppShellLink(product.assistant.href, currentPath) ? "page" : undefined}
                aria-label={assistantLabel}
                className={isActiveAppShellLink(product.assistant.href, currentPath) ? "hidden items-center justify-center rounded-full bg-muted p-1.5 text-sm font-semibold text-foreground sm:inline-flex" : "hidden items-center justify-center rounded-full p-1.5 text-sm font-semibold text-muted-foreground transition hover:bg-muted hover:text-foreground sm:inline-flex"}
                href={product.assistant.href}
              >
                {product.assistant.imageSrc ? (
                  <img
                    alt=""
                    className="size-8 rounded-full border object-cover object-[78%_68%]"
                    src={product.assistant.imageSrc}
                  />
                ) : (
                  <span>{product.assistant.name}</span>
                )}
              </a>
            ) : null}
            <MobileDrawerNav assistant={product.assistant} assistantLabel={assistantLabel} currentPath={currentPath} label={labels?.mobileNavigation} links={navLinks} triggerLabel={labels?.openNavigation} />
          </div>
        </div>
      </header>
      <main className="mx-auto max-w-6xl px-4 py-8">{children}</main>
      <AvAppFooter labels={footerLabels} product={product} />
    </div>
  );
}

export function isActiveAppShellLink(href: string, currentPath?: string) {
  if (!currentPath) {
    return false;
  }
  const hrefPath = href.includes("?") ? href.slice(0, href.indexOf("?")) : href;
  if (hrefPath === "/") {
    return currentPath === "/";
  }
  return currentPath === hrefPath || currentPath.startsWith(`${hrefPath}/`);
}
