import { MenuIcon } from "lucide-react";
import type { AppsAvProductLink } from "../config/product-config";
import { isActiveAppShellLink } from "./app-shell";

export interface MobileDrawerNavProps {
  currentPath?: string;
  label?: string;
  links: AppsAvProductLink[];
  triggerLabel?: string;
}

export function MobileDrawerNav({ currentPath, label = "Mobile navigation", links, triggerLabel = "Open navigation" }: MobileDrawerNavProps) {
  return (
    <details className="md:hidden">
      <summary className="inline-flex size-10 cursor-pointer list-none items-center justify-center rounded-md border bg-background">
        <MenuIcon aria-hidden="true" />
        <span className="sr-only">{triggerLabel}</span>
      </summary>
      <nav className="absolute left-4 right-4 top-16 z-20 rounded-lg border bg-background p-3 shadow-lg" aria-label={label}>
        <div className="flex flex-col gap-1">
          {links.map((link) => (
            <a
              key={link.href}
              aria-current={isActiveAppShellLink(link.href, currentPath) ? "page" : undefined}
              className={isActiveAppShellLink(link.href, currentPath) ? "rounded-md bg-muted px-3 py-2 text-sm font-semibold text-foreground" : "rounded-md px-3 py-2 text-sm font-medium hover:bg-muted"}
              href={link.href}
            >
              {link.label}
            </a>
          ))}
        </div>
      </nav>
    </details>
  );
}
