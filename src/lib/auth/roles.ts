import { z } from "zod";

export const accountRoles = ["buyer", "landowner", "developer", "professional"] as const;

export const accountRoleSchema = z.enum(accountRoles);

export type AccountRole = z.infer<typeof accountRoleSchema>;