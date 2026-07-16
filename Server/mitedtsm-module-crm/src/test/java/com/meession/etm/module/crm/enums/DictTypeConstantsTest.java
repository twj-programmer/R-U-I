package com.meession.etm.module.crm.enums;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class DictTypeConstantsTest {

    @Test
    void testCrmBusinessLoseReasonConstant() {
        assertEquals("crm_business_lose_reason", DictTypeConstants.CRM_BUSINESS_LOSE_REASON);
    }

    @Test
    void testAllCrmDictTypeConstantsNotEmpty() {
        assertNotNull(DictTypeConstants.CRM_CUSTOMER_INDUSTRY);
        assertFalse(DictTypeConstants.CRM_CUSTOMER_INDUSTRY.isEmpty());
        
        assertNotNull(DictTypeConstants.CRM_CUSTOMER_LEVEL);
        assertFalse(DictTypeConstants.CRM_CUSTOMER_LEVEL.isEmpty());
        
        assertNotNull(DictTypeConstants.CRM_CUSTOMER_SOURCE);
        assertFalse(DictTypeConstants.CRM_CUSTOMER_SOURCE.isEmpty());
        
        assertNotNull(DictTypeConstants.CRM_AUDIT_STATUS);
        assertFalse(DictTypeConstants.CRM_AUDIT_STATUS.isEmpty());
        
        assertNotNull(DictTypeConstants.CRM_PRODUCT_UNIT);
        assertFalse(DictTypeConstants.CRM_PRODUCT_UNIT.isEmpty());
        
        assertNotNull(DictTypeConstants.CRM_PRODUCT_STATUS);
        assertFalse(DictTypeConstants.CRM_PRODUCT_STATUS.isEmpty());
        
        assertNotNull(DictTypeConstants.CRM_FOLLOW_UP_TYPE);
        assertFalse(DictTypeConstants.CRM_FOLLOW_UP_TYPE.isEmpty());
        
        assertNotNull(DictTypeConstants.CRM_RECEIVABLE_RETURN_TYPE);
        assertFalse(DictTypeConstants.CRM_RECEIVABLE_RETURN_TYPE.isEmpty());
        
        assertNotNull(DictTypeConstants.CRM_BUSINESS_LOSE_REASON);
        assertFalse(DictTypeConstants.CRM_BUSINESS_LOSE_REASON.isEmpty());
    }

    @Test
    void testCrmBusinessLoseReasonMatchesFrontendConstant() {
        String expectedValue = "crm_business_lose_reason";
        assertEquals(expectedValue, DictTypeConstants.CRM_BUSINESS_LOSE_REASON);
    }
}
