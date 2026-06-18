import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import type { ReactNode } from "react";
import { useState } from "react";
import { Toaster } from "sonner";
import { AppsAvLocaleContext, useManagedAppsAvLocale } from "../lib/locale";
import type { AppsAvLocale } from "../config/product-config";

export interface AppsAvWebProviderProps {
  children: ReactNode;
  initialLocale?: AppsAvLocale;
  queryClient?: QueryClient;
}

export function AppsAvWebProvider({ children, initialLocale = "en", queryClient }: AppsAvWebProviderProps) {
  const locale = useManagedAppsAvLocale(initialLocale);
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
