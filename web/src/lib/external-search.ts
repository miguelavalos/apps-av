export const appsAvExternalSearchEngines = ["google", "duckduckgo", "bing"] as const;

export type AppsAvExternalSearchEngine = (typeof appsAvExternalSearchEngines)[number];

export type AppsAvExternalSearchUrlOptions = {
  engine?: AppsAvExternalSearchEngine | string | null;
  query: string;
};

export function normalizeAppsAvExternalSearchEngine(engine: AppsAvExternalSearchEngine | string | null | undefined): AppsAvExternalSearchEngine {
  if (engine === "duckduckgo" || engine === "bing") {
    return engine;
  }
  return "google";
}

export function appsAvExternalSearchUrl({ engine, query }: AppsAvExternalSearchUrlOptions): string | null {
  const normalizedQuery = query.trim().replace(/\s+/g, " ");
  if (!normalizedQuery) {
    return null;
  }

  const selectedEngine = normalizeAppsAvExternalSearchEngine(engine);
  const encodedQuery = encodeURIComponent(normalizedQuery);
  switch (selectedEngine) {
    case "bing":
      return `https://www.bing.com/search?q=${encodedQuery}`;
    case "duckduckgo":
      return `https://duckduckgo.com/?q=${encodedQuery}`;
    case "google":
      return `https://www.google.com/search?q=${encodedQuery}`;
  }
}

export function appsAvImdbSearchUrl(query: string): string | null {
  const normalizedQuery = query.trim().replace(/\s+/g, " ");
  return normalizedQuery ? `https://www.imdb.com/find/?q=${encodeURIComponent(normalizedQuery)}` : null;
}
