package com.meession.etm.module.crm.service.customer;

import com.meession.etm.framework.common.util.object.BeanUtils;
import com.meession.etm.module.crm.controller.admin.customer.vo.poolconfig.CrmCustomerPoolConfigSaveReqVO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerPoolConfigDO;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerPoolConfigMapper;
import com.mzt.logapi.context.LogRecordContext;
import com.mzt.logapi.starter.annotation.LogRecord;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.Objects;

import static com.meession.etm.module.crm.enums.LogRecordConstants.*;

/**
 * 客户公海配置 Service 实现类
 *
 * @author Wanwan
 */
@Service
@Validated
public class CrmCustomerPoolConfigServiceImpl implements CrmCustomerPoolConfigService {

    @Resource
    private CrmCustomerPoolConfigMapper customerPoolConfigMapper;

    @Override
    public CrmCustomerPoolConfigDO getCustomerPoolConfig() {
        CrmCustomerPoolConfigDO config = customerPoolConfigMapper.selectOne();
        if (config == null) {
            return null;
        }
        if (config.getReceiveLimitPerDay() == null) {
            config.setReceiveLimitPerDay(10);
        }
        if (config.getReceiveCooldownDays() == null) {
            config.setReceiveCooldownDays(30);
        }
        return config;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public CrmCustomerPoolConfigDO getOrCreateCustomerPoolConfigForUpdate() {
        CrmCustomerPoolConfigDO config = customerPoolConfigMapper.selectOneForUpdate();
        if (config == null) {
            try {
                customerPoolConfigMapper.insert(CrmCustomerPoolConfigDO.builder()
                        .enabled(false).receiveLimitPerDay(10).receiveCooldownDays(30).build());
            } catch (DuplicateKeyException ignored) {
                // Another receive transaction created the tenant row first. Re-read it below.
            }
            config = customerPoolConfigMapper.selectOneForUpdate();
        }
        if (config == null) {
            throw new IllegalStateException("CRM customer pool configuration was not created");
        }
        if (config.getReceiveLimitPerDay() == null) {
            config.setReceiveLimitPerDay(10);
        }
        if (config.getReceiveCooldownDays() == null) {
            config.setReceiveCooldownDays(30);
        }
        return config;
    }

    @Override
    @LogRecord(type = CRM_CUSTOMER_POOL_CONFIG_TYPE, subType = CRM_CUSTOMER_POOL_CONFIG_SUB_TYPE, bizNo = "{{#poolConfigId}}",
            success = CRM_CUSTOMER_POOL_CONFIG_SUCCESS)
    public void saveCustomerPoolConfig(CrmCustomerPoolConfigSaveReqVO saveReqVO) {
        // 1. 存在，则进行更新
        CrmCustomerPoolConfigDO dbConfig = getCustomerPoolConfig();
        CrmCustomerPoolConfigDO poolConfig = BeanUtils.toBean(saveReqVO, CrmCustomerPoolConfigDO.class);
        if (Objects.nonNull(dbConfig)) {
            customerPoolConfigMapper.updateById(poolConfig.setId(dbConfig.getId()));
            // 记录操作日志上下文
            LogRecordContext.putVariable("isPoolConfigUpdate", Boolean.TRUE);
            LogRecordContext.putVariable("poolConfigId", poolConfig.getId());
            return;
        }

        // 2. 不存在，则进行插入
        customerPoolConfigMapper.insert(poolConfig);
        // 记录操作日志上下文
        LogRecordContext.putVariable("isPoolConfigUpdate", Boolean.FALSE);
        LogRecordContext.putVariable("poolConfigId", poolConfig.getId());
    }

}
