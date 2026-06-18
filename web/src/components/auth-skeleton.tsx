export function AuthSkeleton() {
  return (
    <div className="min-h-screen bg-background px-5 py-6 text-foreground">
      <div className="mx-auto flex max-w-6xl flex-col gap-8">
        <div className="h-12 rounded-2xl border bg-card" />
        <div className="grid gap-4 md:grid-cols-[0.8fr_1.2fr]">
          <div className="h-72 rounded-2xl border bg-card" />
          <div className="h-72 rounded-2xl border bg-card" />
        </div>
      </div>
    </div>
  );
}
