import type { AppsAvProductLink } from "../config/product-config";

export interface LegalLinkListProps {
  links: AppsAvProductLink[];
}

export function LegalLinkList({ links }: LegalLinkListProps) {
  return (
    <nav aria-label="Legal and support links" className="flex flex-wrap items-center justify-center gap-x-4 gap-y-2 text-sm text-muted-foreground">
      {links.map((link) => (
        <a
          key={link.href}
          className="hover:text-foreground"
          href={link.href}
          rel={link.external ? "noreferrer" : undefined}
          target={link.external ? "_blank" : undefined}
        >
          {link.label}
        </a>
      ))}
    </nav>
  );
}
