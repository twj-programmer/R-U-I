package com.meession.etm.module.crm.enums;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class DictTypeConstantsTest {

    @Test
    void testCrmBusinessLoseReasonConstant() {
        assertEquals("crm_business_lose_reason", DictTypeConstants.CRM_BUSINESS_LOSE_REASON);
    }

    @Test
    void testCrmBusinessLoseReasonMatchesFrontendConstant() {
        String frontendConstantValue = "crm_business_lose_reason";
        assertEquals(frontendConstantValue, DictTypeConstants.CRM_BUSINESS_LOSE_REASON);
    }

    @Test
    void testBusinessLoseReasonDictValues() {
        String[] expectedValues = {"COMPETITOR", "PRICE", "REQUIREMENT_MISMATCH", "BUDGET", "TIMING", "OTHER"};
        assertEquals(6, expectedValues.length);
        
        for (String value : expectedValues) {
            assertNotNull(value);
            assertFalse(value.isEmpty());
        }
    }

    @Test
    void testBusinessLoseReasonSortOrder() {
        int[] expectedSortOrder = {1, 2, 3, 4, 5, 6};
        for (int i = 0; i < expectedSortOrder.length; i++) {
            assertEquals(i + 1, expectedSortOrder[i]);
        }
    }

    @Test
    void testDictTypeConstantsFormat() {
        assertTrue(DictTypeConstants.CRM_BUSINESS_LOSE_REASON.startsWith("crm_"));
        assertTrue(DictTypeConstants.CRM_BUSINESS_LOSE_REASON.contains("lose_reason"));
    }

}
