#!/usr/bin/env node

const defaultLocales = ["en", "es", "fr", "de", "ca"];
const defaultFailurePattern = /(Something went wrong|The requested module|Internal Server Error|Unhandled Runtime Error|ReferenceError|TypeError)/i;
const defaultGuestCopyPattern = /\b(guest|guest-mode|invitado|invitada|convidat|convidada|gastmodus)\b/i;

export async function runSharedWebSmokeQa(config) {
  const normalizedConfig = normalizeConfig(config);
  const failures = [];

  for (const locale of normalizedConfig.locales) {
    for (const route of normalizedConfig.routes) {
      const url = localizedUrl(normalizedConfig.baseUrl, route, locale);
      const response = await fetch(url, { redirect: "manual" });
      const html = await response.text();
      const normalized = normalizeText(html);
      const expected = normalizedConfig.expectations[locale];
      const routeLabel = `${locale} ${route}`;

      check(failures, response.status === 200, `${routeLabel} returns 200`, `${response.status} from ${url}`);
      check(failures, normalized.includes(normalizedConfig.productIdentity), `${routeLabel} renders product identity`);
      check(failures, normalized.includes(`<html lang="${locale}"`), `${routeLabel} sets html lang`);
      check(failures, !normalizedConfig.failurePattern.test(normalized), `${routeLabel} has no runtime error marker`);
      check(failures, !normalizedConfig.guestCopyPattern.test(normalized), `${routeLabel} has no guest product copy`);

      if (route === normalizedConfig.publicRoute) {
        check(
          failures,
          normalized.includes(expected.publicCopy),
          `${locale} public home renders localized public copy`
        );
      }

      if (normalizedConfig.protectedRoutes.includes(route)) {
        check(
          failures,
          normalized.includes(expected.protectedTitle) && normalized.includes(expected.signInCopy),
          `${routeLabel} shows signed-out protection gate`
        );
      }

      check(
        failures,
        ownLinksPreserveLocale(html, locale, normalizedConfig),
        `${routeLabel} keeps locale on product-owned links`
      );
    }
  }

  if (failures.length > 0) {
    console.error(`${normalizedConfig.name} shared web QA failed (${failures.length}):`);
    for (const failure of failures) {
      console.error(`- ${failure}`);
    }
    return { failures, passed: false };
  }

  console.log(
    `${normalizedConfig.name} shared web QA passed for ${normalizedConfig.locales.length} locales and ${normalizedConfig.routes.length} routes at ${normalizedConfig.baseUrl}.`
  );
  return { failures, passed: true };
}

export function normalizeText(value) {
  return value
    .normalize("NFD")
    .replace(/\p{Diacritic}/gu, "")
    .replace(/&amp;/g, "&")
    .replace(/&#x27;/g, "'")
    .replace(/\s+/g, " ");
}

function normalizeConfig(config) {
  const baseUrl = (config.baseUrl ?? "http://localhost:5173").replace(/\/+$/, "");
  const locales = config.locales ?? defaultLocales;
  const routes = config.routes ?? ["/"];
  const publicRoute = config.publicRoute ?? "/";
  const protectedRoutes = config.protectedRoutes ?? routes.filter((route) => route !== publicRoute);
  const ownRoutePrefixes = config.ownRoutePrefixes ?? routes;

  return {
    baseUrl,
    expectations: config.expectations,
    failurePattern: config.failurePattern ?? defaultFailurePattern,
    guestCopyPattern: config.guestCopyPattern ?? defaultGuestCopyPattern,
    locales,
    name: config.name,
    ownRoutePrefixes,
    productIdentity: config.productIdentity,
    protectedRoutes,
    publicRoute,
    routes
  };
}

function localizedUrl(baseUrl, route, locale) {
  const path = locale === "en" ? route : `${route}?lang=${locale}`;
  return `${baseUrl}${path}`;
}

function check(failures, condition, label, detail) {
  if (!condition) {
    failures.push(detail ? `${label}: ${detail}` : label);
  }
}

function ownLinksPreserveLocale(html, locale, config) {
  if (locale === "en") {
    return true;
  }

  const hrefs = Array.from(html.matchAll(/\shref="([^"]+)"/g), (match) =>
    match[1].replace(/&amp;/g, "&")
  );

  const ownRouteHrefs = hrefs.filter((href) => {
    if (!href.startsWith("/")) {
      return false;
    }
    if (href.startsWith("/assets/") || href.startsWith("/@") || href.startsWith("/_")) {
      return false;
    }
    return config.ownRoutePrefixes.some((prefix) =>
      prefix === "/" ? href === "/" || href.startsWith("/?") : href.startsWith(prefix)
    );
  });

  return ownRouteHrefs.every((href) => {
    const parsed = new URL(href, config.baseUrl);
    return parsed.searchParams.get("lang") === locale;
  });
}
