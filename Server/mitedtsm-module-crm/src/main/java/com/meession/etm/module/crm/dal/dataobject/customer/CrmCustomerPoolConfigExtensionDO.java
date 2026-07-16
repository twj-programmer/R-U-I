package com.meession.etm.module.crm.dal.dataobject.customer;

import com.meession.etm.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

@TableName(value = "crm_customer_pool_config")
@KeySequence("crm_customer_pool_config_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CrmCustomerPoolConfigExtensionDO extends TenantBaseDO {

    @TableId
    private Long id;

    private Boolean enabled;

    private Integer contactExpireDays;

    private Integer dealExpireDays;

    private Boolean notifyEnabled;

    private Integer notifyDays;

    private Integer receiveLimitPerDay;

    private Integer receiveCooldownDays;

}