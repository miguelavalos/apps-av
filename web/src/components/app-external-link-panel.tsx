import { ExternalLink } from "lucide-react";
import type { ReactNode } from "react";

export interface AppExternalLinkItem {
  href: string;
  icon?: ReactNode;
  label: string;
}

export interface AppExternalLinkPanelProps {
  links: AppExternalLinkItem[];
  title: string;
}

export function AppExternalLinkPanel({ links, title }: AppExternalLinkPanelProps) {
  if (links.length === 0) {
    return null;
  }

  return (
    <section className="rounded-lg border border-[#d7c494] bg-white/45 p-4">
      <p className="text-sm font-bold text-[#112a55]">{title}</p>
      <div className="mt-3 flex flex-wrap gap-2">
        {links.map((source) => (
          <a
            key={source.href}
            className="inline-flex min-h-10 items-center gap-2 rounded-full border border-[#c8ad72] bg-[#fff8df]/80 px-4 text-sm font-bold text-[#112a55] hover:bg-white"
            href={source.href}
            rel="noreferrer"
            target="_blank"
          >
            {source.icon}
            {source.label}
            <ExternalLink className="size-3.5" aria-hidden="true" />
          </a>
        ))}
      </div>
    </section>
  );
}
