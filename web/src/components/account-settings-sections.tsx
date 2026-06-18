import type { ReactNode } from "react";
import { BadgeCheck, Cloud, CloudOff, Cloudy, Code2, Database, GitBranch, HelpCircle, LibraryBig, ShieldAlert, Sparkles, Trash2, XCircle } from "lucide-react";
import { SettingsButton, SettingsInfoRow, SettingsSectionCard } from "./settings-profile";

export interface SettingsExternalButtonProps {
  children: ReactNode;
  href?: string;
  tone?: "primary" | "secondary" | "danger";
}

export function SettingsExternalButton({ children, href, tone = "secondary" }: SettingsExternalButtonProps) {
  if (!href) {
    return null;
  }
  return (
    <a
      className={
        tone === "primary"
          ? "inline-flex h-10 items-center justify-center rounded-full bg-[#112a55] px-4 text-sm font-semibold text-white hover:bg-[#19396f]"
          : tone === "danger"
            ? "inline-flex h-10 items-center justify-center rounded-full border border-red-200 bg-white/60 px-4 text-sm font-semibold text-red-700 hover:bg-red-50"
            : "inline-flex h-10 items-center justify-center rounded-full border border-[#c8ad72] bg-white/60 px-4 text-sm font-semibold text-[#112a55] hover:bg-white"
      }
      href={href}
    >
      {children}
    </a>
  );
}

export interface SettingsExternalRowLinkProps {
  href?: string;
  label: string;
}

export function SettingsExternalRowLink({ href, label }: SettingsExternalRowLinkProps) {
  if (!href) {
    return null;
  }
  return (
    <a className="text-sm font-semibold text-[#112a55] underline" href={href}>
      {label}
    </a>
  );
}

export interface PlanFeatureLabels {
  accountDetail: string;
  accountTitle: string;
  assistantDetail: string;
  assistantTitle: string;
  libraryDetail: string;
  libraryTitle: string;
  manage: string;
  subtitleFree: string;
  subtitlePro: string;
  title: string;
  upgrade: string;
}

export interface PlanFeatureSectionProps {
  isPro: boolean;
  labels: PlanFeatureLabels;
  manageHref?: string;
}

export function PlanFeatureSection({ isPro, labels, manageHref }: PlanFeatureSectionProps) {
  return (
    <SettingsSectionCard title={labels.title} subtitle={isPro ? labels.subtitlePro : labels.subtitleFree}>
      <SettingsInfoRow icon={<BadgeCheck className="size-5" />} title={labels.accountTitle} detail={labels.accountDetail} />
      <SettingsInfoRow icon={<LibraryBig className="size-5" />} title={labels.libraryTitle} detail={labels.libraryDetail} />
      <SettingsInfoRow icon={<Sparkles className="size-5" />} title={labels.assistantTitle} detail={labels.assistantDetail} />
      <SettingsExternalButton href={manageHref} tone="primary">
        {isPro ? labels.manage : labels.upgrade}
      </SettingsExternalButton>
    </SettingsSectionCard>
  );
}

export type AppSyncState = "disabled" | "idle" | "syncing" | "failed" | "error" | string;

export interface CloudSyncLabels {
  detailDisabled: string;
  detailFailed: string;
  detailSynced: string;
  detailSyncing: string;
  headlineDisabled: string;
  headlineFailed: string;
  headlineSynced: string;
  headlineSyncing: string;
  retry: string;
  retrySyncing: string;
  subtitle: string;
  title: string;
}

export interface CloudSyncSectionProps {
  error?: string | null;
  labels: CloudSyncLabels;
  onRetry: () => void;
  syncState: AppSyncState;
}

export function CloudSyncSection({ error, labels, onRetry, syncState }: CloudSyncSectionProps) {
  const isSyncing = syncState === "syncing";

  return (
    <SettingsSectionCard title={labels.title} subtitle={labels.subtitle}>
      <SettingsInfoRow icon={syncIcon(syncState)} title={syncHeadline(labels, syncState)} detail={syncDetail(labels, syncState)} />
      <SettingsButton disabled={isSyncing} loading={isSyncing} onClick={onRetry}>
        {isSyncing ? labels.retrySyncing : labels.retry}
      </SettingsButton>
      {error ? <p className="text-sm font-semibold text-red-700">{error}</p> : null}
    </SettingsSectionCard>
  );
}

function syncIcon(syncState: AppSyncState) {
  if (syncState === "syncing") {
    return <Cloudy className="size-5" />;
  }
  if (syncState === "failed" || syncState === "error") {
    return <XCircle className="size-5" />;
  }
  if (syncState === "disabled") {
    return <CloudOff className="size-5" />;
  }
  return <Cloud className="size-5" />;
}

function syncHeadline(labels: CloudSyncLabels, syncState: AppSyncState) {
  if (syncState === "syncing") return labels.headlineSyncing;
  if (syncState === "failed" || syncState === "error") return labels.headlineFailed;
  if (syncState === "disabled") return labels.headlineDisabled;
  return labels.headlineSynced;
}

function syncDetail(labels: CloudSyncLabels, syncState: AppSyncState) {
  if (syncState === "syncing") return labels.detailSyncing;
  if (syncState === "failed" || syncState === "error") return labels.detailFailed;
  if (syncState === "disabled") return labels.detailDisabled;
  return labels.detailSynced;
}

export interface HelpLegalLabels {
  deleteDetail: string;
  deleteTitle: string;
  openSourceDetail: string;
  openSourceTitle: string;
  privacyDetail: string;
  privacyTitle: string;
  sourceCodeDetail: string;
  sourceCodeTitle: string;
  subtitle: string;
  supportDetail: string;
  supportTitle: string;
  termsDetail: string;
  termsTitle: string;
  title: string;
}

export interface HelpLegalLinks {
  deleteAccount?: string;
  openSource?: string;
  privacy?: string;
  support?: string;
  terms?: string;
}

export interface HelpLegalSectionProps {
  labels: HelpLegalLabels;
  links: HelpLegalLinks;
}

export function HelpLegalSection({ labels, links }: HelpLegalSectionProps) {
  return (
    <SettingsSectionCard title={labels.title} subtitle={labels.subtitle}>
      <SettingsInfoRow icon={<GitBranch className="size-5" />} title={labels.openSourceTitle} detail={labels.openSourceDetail} action={<SettingsExternalRowLink href={links.openSource} label={labels.sourceCodeTitle} />} />
      <SettingsInfoRow icon={<Code2 className="size-5" />} title={labels.sourceCodeTitle} detail={labels.sourceCodeDetail} action={<SettingsExternalRowLink href={links.openSource} label={labels.sourceCodeTitle} />} />
      <SettingsInfoRow icon={<HelpCircle className="size-5" />} title={labels.supportTitle} detail={labels.supportDetail} action={<SettingsExternalRowLink href={links.support} label={labels.supportTitle} />} />
      <SettingsInfoRow icon={<Database className="size-5" />} title={labels.privacyTitle} detail={labels.privacyDetail} action={<SettingsExternalRowLink href={links.privacy} label={labels.privacyTitle} />} />
      <SettingsInfoRow icon={<ShieldAlert className="size-5" />} title={labels.termsTitle} detail={labels.termsDetail} action={<SettingsExternalRowLink href={links.terms} label={labels.termsTitle} />} />
      <SettingsInfoRow icon={<Trash2 className="size-5" />} title={labels.deleteTitle} detail={labels.deleteDetail} action={<SettingsExternalRowLink href={links.deleteAccount} label={labels.deleteTitle} />} />
    </SettingsSectionCard>
  );
}

export interface AccountSafetyLabels {
  deleteDetail: string;
  deleteTitle: string;
  subtitle: string;
  title: string;
}

export interface AccountSafetySectionProps {
  deleteHref?: string;
  labels: AccountSafetyLabels;
}

export function AccountSafetySection({ deleteHref, labels }: AccountSafetySectionProps) {
  return (
    <SettingsSectionCard title={labels.title} subtitle={labels.subtitle} spacing="compact">
      <SettingsInfoRow
        icon={<ShieldAlert className="size-5" />}
        title={labels.deleteTitle}
        detail={labels.deleteDetail}
        action={
          <SettingsExternalButton href={deleteHref} tone="danger">
            {labels.deleteTitle}
          </SettingsExternalButton>
        }
      />
    </SettingsSectionCard>
  );
}
