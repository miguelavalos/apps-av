import { Sparkles } from "lucide-react";
import type { ReactNode } from "react";

export interface AppAssistantBriefCardProps {
  action?: ReactNode;
  body: ReactNode;
  icon?: ReactNode;
  title: string;
}

export function AppAssistantBriefCard({ action, body, icon = <Sparkles className="size-4" aria-hidden="true" />, title }: AppAssistantBriefCardProps) {
  return (
    <section className="rounded-lg border border-[#d7c494] bg-[#10284f] p-5 text-white shadow-lg shadow-[#172f5c]/14">
      <div className="flex items-center gap-2 text-sm font-semibold text-[#b6dd89]">
        {icon}
        {title}
      </div>
      <div className="mt-4 text-sm leading-6 text-white/74">{body}</div>
      {action ? <div className="mt-5">{action}</div> : null}
    </section>
  );
}
