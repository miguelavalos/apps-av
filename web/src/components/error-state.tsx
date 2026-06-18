import type { ReactNode } from "react";
import { cn } from "../lib/cn";

export interface ErrorStateProps {
  title?: string;
  description: string;
  action?: ReactNode;
  className?: string;
}

export function ErrorState({ title = "Something went wrong", description, action, className }: ErrorStateProps) {
  return (
    <section className={cn("rounded-lg border border-destructive/30 bg-card p-6 text-card-foreground", className)}>
      <h2 className="text-lg font-semibold">{title}</h2>
      <p className="mt-2 text-sm leading-6 text-muted-foreground">{description}</p>
      {action ? <div className="mt-4">{action}</div> : null}
    </section>
  );
}
