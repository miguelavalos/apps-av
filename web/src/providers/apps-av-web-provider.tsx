import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import type { ReactNode } from "react";
import { useEffect, useState } from "react";
import { Toaster } from "sonner";
import { AppsAvLocaleContext, setAppsAvLocale, useManagedAppsAvLocale } from "../lib/locale";
import type { AppsAvLocale } from "../config/product-config";

export interface AppsAvWebProviderProps {
  children: ReactNode;
  fixedLocale?: AppsAvLocale;
  initialLocale?: AppsAvLocale;
  queryClient?: QueryClient;
  supportedLocales?: readonly AppsAvLocale[];
}

export function AppsAvWebProvider({ children, fixedLocale, initialLocale = "en", queryClient, supportedLocales }: AppsAvWebProviderProps) {
  const managedLocale = useManagedAppsAvLocale(initialLocale, supportedLocales);
  const locale = fixedLocale ?? managedLocale;

  useEffect(() => {
    if (fixedLocale) {
      setAppsAvLocale(fixedLocale);
    }
  }, [fixedLocale]);
  const [client] = useState(
    () =>
      queryClient ??
      new QueryClient({
        defaultOptions: {
          queries: {
            refetchOnWindowFocus: false,
            retry: 1,
            staleTime: 30_000
          }
        }
      })
  );

  return (
    <QueryClientProvider client={client}>
      <AppsAvLocaleContext.Provider value={locale}>
        {children}
        <Toaster richColors />
      </AppsAvLocaleContext.Provider>
    </QueryClientProvider>
  );
}
