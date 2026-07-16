package com.meession.etm.module.crm.enums;

import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertTrue;

class BusinessLoseReasonMigrationSqlContractTest {

    private static final String MARKER = "D2-MKT-01:20260716";
    private static final List<String> LOSE_REASON_CODES = List.of(
            "COMPETITOR", "PRICE", "REQUIREMENT_MISMATCH", "BUDGET", "TIMING", "OTHER");

    @Test
    void forwardMigration_shouldGuardExistingDataAndRemainIdempotent() throws IOException {
        String sql = readSql("20260716_d2_business_lose_reason_dict.sql");

        assertTrue(sql.contains("CREATE PROCEDURE IF NOT EXISTS migrate_business_lose_reason_dict()"));
        assertTrue(sql.contains("DROP PROCEDURE IF EXISTS migrate_business_lose_reason_dict"));
        assertTrue(sql.contains(MARKER));
        assertTrue(sql.contains("migration aborted: existing dictionary data is not owned by this migration"));
        assertTrue(sql.contains("START TRANSACTION"));
        assertTrue(sql.contains("COMMIT"));
        for (String code : LOSE_REASON_CODES) {
            assertTrue(sql.contains("'" + code + "'"));
        }
    }

    @Test
    void rollbackMigration_shouldOnlyDeleteOwnedUnchangedDataAndBlockReferences() throws IOException {
        String sql = readSql("20260716_d2_business_lose_reason_dict_rollback.sql");

        assertTrue(sql.contains("dictionary contains data not owned by this migration"));
        assertTrue(sql.contains("DROP PROCEDURE IF EXISTS rollback_business_lose_reason_dict"));
        assertTrue(sql.contains("dictionary data changed after migration"));
        assertTrue(sql.contains("business records referencing lose reason codes"));
        assertTrue(sql.contains("`dict_type` = 'crm_business_lose_reason' AND `remark` = source_marker"));
        assertTrue(sql.contains("`type` = 'crm_business_lose_reason' AND `remark` = source_marker"));
    }

    private static String readSql(String fileName) throws IOException {
        Path current = Path.of("").toAbsolutePath();
        while (current != null) {
            Path candidate = current.resolve("database").resolve("new").resolve(fileName);
            if (Files.isRegularFile(candidate)) {
                return Files.readString(candidate, StandardCharsets.UTF_8);
            }
            current = current.getParent();
        }
        throw new IOException("Cannot locate database/new/" + fileName);
    }

}
