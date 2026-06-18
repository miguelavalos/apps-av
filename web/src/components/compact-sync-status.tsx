import { CheckCircle2, CloudOff, Loader2, XCircle } from "lucide-react";

export type CompactSyncState = "disabled" | "idle" | "syncing" | "failed" | "error" | string;

export interface CompactSyncStatusLabels {
  disabled: string;
  failed: string;
  idle: string;
  syncing: string;
}

export interface CompactSyncStatusProps {
  labels: CompactSyncStatusLabels;
  syncState: CompactSyncState;
}

export function CompactSyncStatus({ labels, syncState }: CompactSyncStatusProps) {
  const config = compactSyncConfig(labels, syncState);
  return (
    <span className="inline-flex items-center gap-1.5 rounded-full border border-[#d7c494] bg-[#fff8df]/72 px-2.5 py-1 text-xs font-semibold text-[#53617a]">
      {config.icon}
      {config.label}
    </span>
  );
}

function compactSyncConfig(labels: CompactSyncStatusLabels, syncState: CompactSyncState) {
  if (syncState === "syncing") {
    return { icon: <Loader2 className="size-3.5 animate-spin text-[#5a8f2f]" />, label: labels.syncing };
  }
  if (syncState === "failed" || syncState === "error") {
    return { icon: <XCircle className="size-3.5 text-red-700" />, label: labels.failed };
  }
  if (syncState === "disabled") {
    return { icon: <CloudOff className="size-3.5 text-[#53617a]" />, label: labels.disabled };
  }
  return { icon: <CheckCircle2 className="size-3.5 text-[#5a8f2f]" />, label: labels.idle };
}

