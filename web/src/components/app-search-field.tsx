import { Search } from "lucide-react";
import type { ChangeEventHandler, InputHTMLAttributes } from "react";

export interface AppSearchFieldProps extends Omit<InputHTMLAttributes<HTMLInputElement>, "onChange" | "value"> {
  onValueChange: (value: string) => void;
  value: string;
}

export function AppSearchField({ className = "", onValueChange, type = "search", value, ...props }: AppSearchFieldProps) {
  const handleChange: ChangeEventHandler<HTMLInputElement> = (event) => {
    onValueChange(event.target.value);
  };

  return (
    <div className={`relative ${className}`}>
      <Search aria-hidden="true" className="pointer-events-none absolute left-4 top-1/2 size-4 -translate-y-1/2 text-[#5a8f2f]" />
      <input
        {...props}
        className="h-11 w-full rounded-full border border-[#d7c494] bg-[#fff8df] pl-11 pr-4 text-[#112a55] outline-none transition placeholder:text-[#748098] focus:border-[#5a8f2f] focus:ring-2 focus:ring-[#5a8f2f]/20"
        type={type}
        value={value}
        onChange={handleChange}
      />
    </div>
  );
}
