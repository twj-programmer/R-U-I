package com.meession.etm.module.crm.service.customer;

import com.meession.etm.module.crm.controller.admin.customer.vo.poolconfig.CrmCustomerPoolConfigSaveReqVO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerPoolConfigDO;

import jakarta.validation.Valid;

/**
 * 客户公海配置 Service 接口
 *
 * @author Wanwan
 */
public interface CrmCustomerPoolConfigService {

    /**
     * 获得客户公海配置
     *
     * @return 客户公海配置
     */
    CrmCustomerPoolConfigDO getCustomerPoolConfig();

    /**
     * Gets a configuration row for the current tenant and locks it for a receive transaction.
     * A missing row is created with the V1.5 defaults and then read again under the row lock.
     */
    CrmCustomerPoolConfigDO getOrCreateCustomerPoolConfigForUpdate();

    /**
     * 保存客户公海配置
     *
     * @param saveReqVO 更新信息
     */
    void saveCustomerPoolConfig(@Valid CrmCustomerPoolConfigSaveReqVO saveReqVO);

}
