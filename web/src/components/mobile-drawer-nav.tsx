import { MenuIcon } from "lucide-react";
import type { AppsAvProductLink } from "../config/product-config";

export interface MobileDrawerNavProps {
  links: AppsAvProductLink[];
}

export function MobileDrawerNav({ links }: MobileDrawerNavProps) {
  return (
    <details className="md:hidden">
      <summary className="inline-flex size-10 cursor-pointer list-none items-center justify-center rounded-md border bg-background">
        <MenuIcon aria-hidden="true" />
        <span className="sr-only">Open navigation</span>
      </summary>
      <nav className="absolute left-4 right-4 top-16 z-20 rounded-lg border bg-background p-3 shadow-lg" aria-label="Mobile navigation">
        <div className="flex flex-col gap-1">
          {links.map((link) => (
            <a key={link.href} className="rounded-md px-3 py-2 text-sm font-medium hover:bg-muted" href={link.href}>
              {link.label}
            </a>
          ))}
        </div>
      </nav>
    </details>
  );
}
