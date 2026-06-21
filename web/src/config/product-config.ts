export interface AppsAvProductLink {
  href: string;
  label: string;
  external?: boolean;
}

export type AppsAvLocale = "en" | "es" | "fr" | "de" | "ca";

export const appsAvLocales: AppsAvLocale[] = ["en", "es", "fr", "de", "ca"];

export const appsAvLocaleNames: Record<AppsAvLocale, string> = {
  ca: "Català",
  de: "Deutsch",
  en: "English",
  es: "Español",
  fr: "Français"
};

export const appsAvLocaleCookieName = "preferred_locale";

export const appsAvLocaleChangeEvent = "apps-av-locale-change";

export interface AppsAvProductAssistant {
  href: string;
  imageSrc?: string;
  label: string;
  name: string;
}

export interface AppsAvProductConfig {
  appId: string;
  name: string;
  logoSrc?: string;
  logoDarkSrc?: string;
  iconSrc?: string;
  accentColor: string;
  assistant?: AppsAvProductAssistant;
  links: {
    support?: AppsAvProductLink;
    privacy?: AppsAvProductLink;
    terms?: AppsAvProductLink;
    deleteAccount?: AppsAvProductLink;
    suite?: AppsAvProductLink;
    website?: AppsAvProductLink;
  };
}
