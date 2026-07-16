package com.meession.etm.module.crm.enums;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class DictTypeConstantsTest {

    @Test
    void testCrmBusinessLoseReasonConstant() {
        assertEquals("crm_business_lose_reason", DictTypeConstants.CRM_BUSINESS_LOSE_REASON);
    }

    @Test
    void testCrmBusinessLoseReasonConstantNotEmpty() {
        assertNotNull(DictTypeConstants.CRM_BUSINESS_LOSE_REASON);
        assertFalse(DictTypeConstants.CRM_BUSINESS_LOSE_REASON.isEmpty());
    }

}
