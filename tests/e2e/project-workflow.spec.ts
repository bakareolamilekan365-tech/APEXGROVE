import { test } from "@playwright/test";

test("project workflow is reserved", async () => {
  test.skip(
    true,
    "Implement after project workspace persistence is connected.",
  );
});
