export interface AppRowsSkeletonProps {
  labelWidthClassName?: string;
  rowCount?: number;
}

export function AppRowsSkeleton({ labelWidthClassName = "w-20", rowCount = 3 }: AppRowsSkeletonProps) {
  return (
    <section className="grid gap-3" aria-hidden="true">
      <div className={`h-4 animate-pulse rounded-full bg-[#d8c27d]/70 ${labelWidthClassName}`} />
      {Array.from({ length: rowCount }).map((_, index) => (
        <div key={index} className="rounded-lg border border-[#d7c494] bg-[#fff8df]/88 p-4 shadow-sm shadow-[#172f5c]/6">
          <div className="flex gap-4">
            <div className="h-20 w-14 shrink-0 animate-pulse rounded-lg border border-[#d7c494] bg-[#ead6a5]" />
            <div className="min-w-0 flex-1">
              <div className="h-5 w-48 max-w-full animate-pulse rounded-full bg-[#ead6a5]" />
              <div className="mt-3 h-4 w-72 max-w-full animate-pulse rounded-full bg-[#ead6a5]/70" />
              <div className="mt-4 flex gap-2">
                <div className="h-9 w-24 animate-pulse rounded-full bg-[#112a55]/25" />
                <div className="h-9 w-20 animate-pulse rounded-full bg-white/45" />
              </div>
            </div>
          </div>
        </div>
      ))}
    </section>
  );
}
