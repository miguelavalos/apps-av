import type { ReactNode } from "react";
import type { AppsAvProductConfig } from "../config/product-config";
import { AvAppFooter, type AvAppFooterLabels } from "./av-app-footer";

export interface ProtectedAppGateProps {
  body: string;
  cta: string;
  footerLabels?: AvAppFooterLabels;
  logoAlt: string;
  logoSrc?: string;
  mascotAlt?: string;
  mascotSrc?: string;
  product: AppsAvProductConfig;
  signInHref: string;
  title: string;
  wrapperClassName?: string;
}

export function ProtectedAppGate({
  body,
  cta,
  footerLabels,
  logoAlt,
  logoSrc,
  mascotAlt = "",
  mascotSrc,
  product,
  signInHref,
  title,
  wrapperClassName = "series-paper"
}: ProtectedAppGateProps) {
  return (
    <div className={`${wrapperClassName} flex min-h-screen flex-col`}>
      <main className="flex flex-1 items-center justify-center px-6 py-10 text-center">
        <div className="relative max-w-3xl overflow-hidden rounded-[1.75rem] border border-[#d7c494] bg-[#fff8df]/88 p-8 pb-28 shadow-2xl shadow-[#172f5c]/12 sm:p-10 sm:pb-10">
          {logoSrc ? <img className="mx-auto h-auto w-64" src={logoSrc} alt={logoAlt} /> : null}
          <h1 className="mt-8 text-4xl font-semibold text-[#112a55]">{title}</h1>
          <p className="mx-auto mt-4 max-w-xl text-base leading-7 text-[#334766]">{body}</p>
          <a className="mt-8 inline-flex h-11 items-center justify-center rounded-full bg-[#112a55] px-5 text-sm font-semibold text-white shadow-lg shadow-[#112a55]/18 transition hover:bg-[#19396f]" href={signInHref}>
            {cta}
          </a>
          {mascotSrc ? <img className="absolute bottom-0 right-5 w-28 translate-y-6 sm:hidden" src={mascotSrc} alt={mascotAlt} /> : null}
        </div>
      </main>
      <AvAppFooter className="border-transparent bg-transparent" labels={footerLabels} product={product} />
    </div>
  );
}

export interface AppSurfaceStateProps {
  action?: ReactNode;
  description?: string;
  icon?: ReactNode;
  title: string;
}

export function AppSurfaceState({ action, description, icon, title }: AppSurfaceStateProps) {
  return (
    <div className="rounded-lg border border-dashed border-[#c8ad72] bg-[#fff8df]/70 p-8 text-center">
      {icon ? <div className="mx-auto flex size-10 items-center justify-center text-[#5a8f2f]">{icon}</div> : null}
      <h2 className="mt-4 text-2xl font-semibold text-[#112a55]">{title}</h2>
      {description ? <p className="mx-auto mt-3 max-w-lg text-sm leading-6 text-[#53617a]">{description}</p> : null}
      {action ? <div className="mt-5">{action}</div> : null}
    </div>
  );
}

