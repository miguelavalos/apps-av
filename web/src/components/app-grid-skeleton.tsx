export interface AppGridSkeletonProps {
  className?: string;
  itemClassName?: string;
  itemCount?: number;
}

export function AppGridSkeleton({ className = "grid gap-4 sm:grid-cols-2 xl:grid-cols-3", itemClassName = "h-72 rounded-lg border border-[#d7c494] bg-[#fff8df]", itemCount = 6 }: AppGridSkeletonProps) {
  return (
    <div className={className} aria-hidden="true">
      {Array.from({ length: itemCount }).map((_, index) => (
        <div key={index} className={`animate-pulse ${itemClassName}`} />
      ))}
    </div>
  );
}
