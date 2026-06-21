export interface AppSegmentedControlOption<Value extends string> {
  label: string;
  value: Value;
}

export interface AppSegmentedControlProps<Value extends string> {
  ariaLabel?: string;
  className?: string;
  onValueChange: (value: Value) => void;
  options: AppSegmentedControlOption<Value>[];
  value: Value;
}

export function AppSegmentedControl<Value extends string>({ ariaLabel, className = "", onValueChange, options, value }: AppSegmentedControlProps<Value>) {
  return (
    <div className={`flex flex-wrap gap-2 ${className}`} role="group" aria-label={ariaLabel}>
      {options.map((option) => {
        const isSelected = option.value === value;
        return (
          <button
            key={option.value}
            aria-pressed={isSelected}
            className={isSelected ? "rounded-full bg-[#112a55] px-3 py-2 text-sm font-semibold text-white" : "rounded-full border border-[#d7c494] bg-[#fff8df]/80 px-3 py-2 text-sm font-semibold text-[#334766] transition hover:bg-white"}
            type="button"
            onClick={() => onValueChange(option.value)}
          >
            {option.label}
          </button>
        );
      })}
    </div>
  );
}
