import type { ReactNode } from "react";
import type { AppsAvProductConfig, AppsAvProductLink } from "../config/product-config";
import { AvAppFooter, type AvAppFooterLabels } from "./av-app-footer";
import { MobileDrawerNav } from "./mobile-drawer-nav";

export interface AppShellProps {
  product: AppsAvProductConfig;
  navLinks: AppsAvProductLink[];
  accountArea?: ReactNode;
  children: ReactNode;
  footerLabels?: AvAppFooterLabels;
}

export function AppShell({ product, navLinks, accountArea, children, footerLabels }: AppShellProps) {
  return (
    <div className="min-h-screen bg-background text-foreground">
      <header className="sticky top-0 z-10 border-b bg-background/88 backdrop-blur">
        <div className="mx-auto flex h-16 max-w-6xl items-center justify-between px-4">
          <a className="flex min-w-0 items-center gap-3" href="/" aria-label={`${product.name} home`}>
            {product.logoSrc ? (
              <img alt="" className="h-9 w-auto max-w-36 object-contain" src={product.logoSrc} />
            ) : (
              <>
                {product.iconSrc ? <img alt="" className="size-8 rounded-md" src={product.iconSrc} /> : null}
                <span className="text-sm font-semibold">{product.name}</span>
              </>
            )}
          </a>
          <nav className="hidden items-center gap-1 md:flex" aria-label="Primary navigation">
            {navLinks.map((link) => (
              <a key={link.href} className="rounded-full px-3 py-2 text-sm font-medium text-muted-foreground hover:bg-muted hover:text-foreground" href={link.href}>
                {link.label}
              </a>
            ))}
          </nav>
          <div className="flex items-center gap-3">
            {accountArea}
            <MobileDrawerNav links={navLinks} />
          </div>
        </div>
      </header>
      <main className="mx-auto max-w-6xl px-4 py-8">{children}</main>
      {product.assistant ? (
        <a
          className="fixed bottom-5 right-4 z-20 flex items-center gap-2 rounded-full border bg-background/92 px-3 py-2 text-sm font-semibold shadow-lg shadow-black/10 backdrop-blur transition hover:-translate-y-0.5 hover:bg-background"
          href={product.assistant.href}
          aria-label={product.assistant.label}
        >
          {product.assistant.imageSrc ? (
            <img
              alt=""
              className="size-10 rounded-full border object-cover object-[78%_68%]"
              src={product.assistant.imageSrc}
            />
          ) : null}
          <span>{product.assistant.name}</span>
        </a>
      ) : null}
      <AvAppFooter labels={footerLabels} product={product} />
    </div>
  );
}
