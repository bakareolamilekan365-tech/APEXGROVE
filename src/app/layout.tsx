import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "APEXGROVE",
  description: "The trusted digital ecosystem for land development in Africa.",
};

export default function RootLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
