import type { ReactNode } from "react";

export interface AppMetricTileProps {
  icon?: ReactNode;
  label: string;
  value: ReactNode;
}

export function AppMetricTile({ icon, label, value }: AppMetricTileProps) {
  return (
    <div className="rounded-lg border border-[#d7c494] bg-[#fff8df]/72 p-4 text-[#112a55]">
      <div className="flex items-center gap-2 text-sm font-semibold">
        {icon ? <span className="text-[#5a8f2f]">{icon}</span> : null}
        {label}
      </div>
      <div className="mt-2 text-lg font-semibold text-[#112a55]">{value}</div>
    </div>
  );
}
