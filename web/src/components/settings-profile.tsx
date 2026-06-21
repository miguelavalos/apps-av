import type { ReactNode } from "react";
import { cn } from "../lib/cn";

export interface SettingsProfileScaffoldProps {
  children: ReactNode;
  heroClassName?: string;
  header?: ReactNode;
  subtitle: string;
  title: string;
}

export function SettingsProfileScaffold({ children, header, heroClassName, subtitle, title }: SettingsProfileScaffoldProps) {
  return (
    <section className="grid gap-6">
      {header}
      <div className={cn("px-1", heroClassName)}>
        <h1 className="text-3xl font-bold leading-tight text-[#112a55] sm:text-[34px]">{title}</h1>
        <p className="mt-2 max-w-2xl text-base font-medium leading-7 text-[#53617a]">{subtitle}</p>
      </div>
      <div className="grid gap-4">{children}</div>
    </section>
  );
}

export interface SettingsSectionCardProps {
  children: ReactNode;
  className?: string;
  spacing?: "normal" | "compact";
  subtitle: string;
  title: string;
}

export function SettingsSectionCard({ children, className, spacing = "normal", subtitle, title }: SettingsSectionCardProps) {
  return (
    <section className={cn("rounded-lg border border-[#d7c494] bg-[#fff8df]/88 p-[22px] text-[#112a55] shadow-sm shadow-[#172f5c]/6", className)}>
      <div>
        <h2 className="text-xl font-bold">{title}</h2>
        <p className="mt-1.5 text-sm font-medium leading-6 text-[#53617a]">{subtitle}</p>
      </div>
      <div className={cn("mt-[18px] grid", spacing === "compact" ? "gap-2.5" : "gap-3")}>{children}</div>
    </section>
  );
}

export interface SettingsInfoRowProps {
  action?: ReactNode;
  detail: string;
  icon: ReactNode;
  title: string;
}

export function SettingsInfoRow({ action, detail, icon, title }: SettingsInfoRowProps) {
  return (
    <div className="flex items-start gap-3">
      <div className="mt-0.5 flex w-[22px] shrink-0 justify-center text-[#3d7f24]">{icon}</div>
      <div className="min-w-0 flex-1">
        <p className="text-sm font-semibold text-[#112a55]">{title}</p>
        <p className="mt-1 text-[13px] font-medium leading-5 text-[#53617a]">{detail}</p>
        {action ? <div className="mt-3">{action}</div> : null}
      </div>
    </div>
  );
}

export interface SettingsActionRowProps extends SettingsInfoRowProps {
  disabled?: boolean;
  onAction: () => void;
}

export function SettingsActionRow({ disabled, onAction, ...row }: SettingsActionRowProps) {
  return (
    <button
      type="button"
      disabled={disabled}
      className="rounded-lg border border-[#d7c494] bg-white/55 p-4 text-left transition hover:bg-white disabled:cursor-not-allowed disabled:opacity-50"
      onClick={onAction}
    >
      <SettingsInfoRow {...row} />
    </button>
  );
}

export interface SettingsButtonProps {
  children: ReactNode;
  disabled?: boolean;
  loading?: boolean;
  onClick?: () => void;
  tone?: "primary" | "secondary" | "danger";
}

export function SettingsButton({ children, disabled, loading, onClick, tone = "secondary" }: SettingsButtonProps) {
  return (
    <button
      type="button"
      disabled={disabled || loading}
      className={cn(
        "inline-flex h-12 w-full items-center justify-center gap-2 rounded-full px-5 text-sm font-bold transition disabled:pointer-events-none disabled:opacity-60",
        tone === "primary" && "bg-[#112a55] text-white hover:bg-[#19396f]",
        tone === "secondary" && "border border-[#c8ad72] bg-white/60 text-[#112a55] hover:bg-white",
        tone === "danger" && "border border-red-200 bg-white/60 text-red-700 hover:bg-red-50"
      )}
      onClick={onClick}
    >
      {children}
    </button>
  );
}

export interface SettingsOption {
  icon?: ReactNode;
  id: string;
  label: string;
}

export interface SettingsOptionButtonGroupProps {
  onSelect: (id: string) => void;
  options: SettingsOption[];
  selectedId: string;
}

export function SettingsOptionButtonGroup({ onSelect, options, selectedId }: SettingsOptionButtonGroupProps) {
  return (
    <div className="grid grid-cols-[repeat(auto-fit,minmax(8rem,1fr))] gap-2.5">
      {options.map((option) => (
        <button
          key={option.id}
          type="button"
          aria-pressed={selectedId === option.id}
          className={cn(
            "inline-flex min-h-12 items-center justify-center gap-2 rounded-lg border px-4 py-3 text-sm font-semibold transition",
            selectedId === option.id
              ? "border-[#112a55] bg-[#112a55] text-white"
              : "border-[#c8ad72] bg-white/60 text-[#112a55] hover:bg-white"
          )}
          data-option-id={option.id}
          onClick={() => onSelect(option.id)}
        >
          {option.icon}
          {option.label}
        </button>
      ))}
    </div>
  );
}

export interface SettingsSelectOption {
  id: string;
  label: string;
}

export interface SettingsSelectProps {
  ariaLabel: string;
  onSelect: (id: string) => void;
  options: SettingsSelectOption[];
  selectedId: string;
}

export function SettingsSelect({ ariaLabel, onSelect, options, selectedId }: SettingsSelectProps) {
  return (
    <label className="grid gap-2">
      <span className="sr-only">{ariaLabel}</span>
      <select
        aria-label={ariaLabel}
        className="h-12 w-full rounded-lg border border-[#d7c494] bg-[#fff8df]/80 px-4 text-sm font-semibold text-[#112a55] outline-none transition focus:border-[#112a55] focus:ring-2 focus:ring-[#112a55]/20"
        value={selectedId}
        onChange={(event) => onSelect(event.target.value)}
      >
        {options.map((option) => (
          <option key={option.id} value={option.id}>
            {option.label}
          </option>
        ))}
      </select>
    </label>
  );
}
