package com.meession.etm.module.crm.service.customer.exception;

import com.meession.etm.framework.common.exception.ErrorCode;

public interface CrmCustomerErrorCode {

    ErrorCode CUSTOMER_RECEIVE_EXCEED_DAILY_LIMIT = new ErrorCode(1_020_006_016, "客户领取超过每日上限");
    ErrorCode CUSTOMER_RECEIVE_COOLDOWN = new ErrorCode(1_020_006_017, "客户领取冷却期内");
    ErrorCode CUSTOMER_PUT_POOL_FAIL_ACTIVE_BUSINESS = new ErrorCode(1_020_006_018, "存在进行中商机，无法移入公海");
    ErrorCode CUSTOMER_RECEIVE_CONCURRENT_CONFLICT = new ErrorCode(1_020_006_019, "客户领取并发冲突");
    ErrorCode CUSTOMER_PERMISSION_DENIED = new ErrorCode(1_020_006_020, "无权限操作该客户");

}