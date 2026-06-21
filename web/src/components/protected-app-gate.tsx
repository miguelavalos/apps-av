import type { ReactNode } from "react";
import type { AppsAvProductConfig } from "../config/product-config";
import { cn } from "../lib/cn";
import { AvAppFooter, type AvAppFooterLabels } from "./av-app-footer";

export interface ProtectedAppGateScene {
  alt?: string;
  body?: string;
  label?: string;
  src: string;
}

export interface ProtectedAppGateProps {
  backgroundAlt?: string;
  backgroundSrc?: string;
  body: string;
  cta: string;
  eyebrow?: string;
  footerLabels?: AvAppFooterLabels;
  logoAlt: string;
  logoSrc?: string;
  mascotAlt?: string;
  mascotSrc?: string;
  product: AppsAvProductConfig;
  scenes?: ProtectedAppGateScene[];
  secondaryCta?: string;
  secondaryHref?: string;
  signInHref: string;
  title: string;
  wrapperClassName?: string;
}

export function ProtectedAppGate({
  backgroundAlt = "",
  backgroundSrc,
  body,
  cta,
  eyebrow,
  footerLabels,
  logoAlt,
  logoSrc,
  mascotAlt = "",
  mascotSrc,
  product,
  scenes = [],
  secondaryCta,
  secondaryHref,
  signInHref,
  title,
  wrapperClassName = "series-paper"
}: ProtectedAppGateProps) {
  const visibleScenes = scenes.slice(0, 3);

  return (
    <div className={cn(wrapperClassName, "relative flex min-h-screen flex-col overflow-hidden")}>
      {backgroundSrc ? (
        <img className="absolute inset-0 h-full w-full object-cover object-center" src={backgroundSrc} alt={backgroundAlt} />
      ) : null}
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_18%_12%,rgba(255,248,223,0.92),rgba(255,248,223,0.34)_38%,rgba(17,42,85,0.24)_100%)]" />
      <main className="relative flex flex-1 items-center px-4 py-10 sm:px-6 lg:px-10">
        <div className="mx-auto grid w-full max-w-6xl items-center gap-5 lg:grid-cols-[minmax(0,1fr)_minmax(320px,0.74fr)]">
          <section className="overflow-hidden rounded-[1.5rem] border border-[#d7c494]/80 bg-[#fff8df]/90 p-6 text-left shadow-2xl shadow-[#172f5c]/14 backdrop-blur-md sm:p-8 lg:p-10">
            {logoSrc ? <img className="h-auto w-44 max-w-full sm:w-56" src={logoSrc} alt={logoAlt} /> : null}
            {eyebrow ? <p className="mt-8 text-xs font-semibold uppercase tracking-[0.18em] text-[#5f7f34]">{eyebrow}</p> : null}
            <h1 className="mt-5 max-w-2xl text-4xl font-semibold leading-tight text-[#112a55] sm:text-5xl">{title}</h1>
            <p className="mt-5 max-w-2xl text-base leading-7 text-[#334766] sm:text-lg">{body}</p>
            <div className="mt-8 flex flex-wrap items-center gap-3">
              <a className="inline-flex min-h-11 items-center justify-center rounded-full bg-[#112a55] px-5 text-sm font-semibold text-white shadow-lg shadow-[#112a55]/18 transition hover:bg-[#19396f] focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#112a55]" href={signInHref}>
                {cta}
              </a>
              {secondaryCta && secondaryHref ? (
                <a className="inline-flex min-h-11 items-center justify-center rounded-full border border-[#c8ad72] bg-white/48 px-5 text-sm font-semibold text-[#112a55] transition hover:bg-white/74 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#112a55]" href={secondaryHref}>
                  {secondaryCta}
                </a>
              ) : null}
            </div>
          </section>

          <aside className="relative min-h-[22rem] overflow-hidden rounded-[1.5rem] border border-white/58 bg-[#fff8df]/68 shadow-2xl shadow-[#172f5c]/16 backdrop-blur-md">
            {visibleScenes[0] ? (
              <img className="absolute inset-0 h-full w-full object-cover object-center" src={visibleScenes[0].src} alt={visibleScenes[0].alt ?? ""} />
            ) : null}
            <div className="absolute inset-0 bg-gradient-to-t from-[#112a55]/78 via-[#112a55]/16 to-transparent" />
            {mascotSrc ? <img className="absolute bottom-3 right-4 w-28 drop-shadow-2xl sm:w-36" src={mascotSrc} alt={mascotAlt} /> : null}
            <div className="absolute bottom-0 left-0 max-w-sm p-5 text-white">
              <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[#f8e6a9]">{product.name}</p>
              <p className="mt-2 text-xl font-semibold leading-snug">{visibleScenes[0]?.label ?? "Avi listo para ayudarte"}</p>
              {visibleScenes[0]?.body ? <p className="mt-2 text-sm leading-6 text-white/86">{visibleScenes[0].body}</p> : null}
            </div>
          </aside>

          {visibleScenes.length > 1 ? (
            <div className="grid gap-4 lg:col-span-2 sm:grid-cols-2">
              {visibleScenes.slice(1).map((scene) => (
                <article key={`${scene.src}-${scene.label ?? ""}`} className="grid min-h-36 grid-cols-[8.5rem_minmax(0,1fr)] overflow-hidden rounded-2xl border border-[#d7c494]/70 bg-[#fff8df]/82 shadow-lg shadow-[#172f5c]/8 backdrop-blur">
                  <img className="h-full min-h-36 w-full object-cover" src={scene.src} alt={scene.alt ?? ""} />
                  <div className="min-w-0 p-4">
                    {scene.label ? <h2 className="text-base font-semibold leading-snug text-[#112a55]">{scene.label}</h2> : null}
                    {scene.body ? <p className="mt-2 text-sm leading-6 text-[#53617a]">{scene.body}</p> : null}
                  </div>
                </article>
              ))}
            </div>
          ) : null}
        </div>
      </main>
      <AvAppFooter className="relative border-transparent bg-[#fff8df]/72 backdrop-blur-md" labels={footerLabels} product={product} />
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
