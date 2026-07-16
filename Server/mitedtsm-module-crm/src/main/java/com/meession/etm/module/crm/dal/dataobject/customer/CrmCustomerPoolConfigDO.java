package com.meession.etm.module.crm.dal.dataobject.customer;

import com.meession.etm.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.*;
import lombok.*;

/**
 * 客户公海配置 DO
 *
 * @author Wanwan
 */
@TableName(value = "crm_customer_pool_config")
@KeySequence("crm_customer_pool_config_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CrmCustomerPoolConfigDO extends TenantBaseDO {

    @TableId
    private Long id;

    private Boolean enabled;

    @TableField(updateStrategy = FieldStrategy.ALWAYS)
    private Integer contactExpireDays;

    @TableField(updateStrategy = FieldStrategy.ALWAYS)
    private Integer dealExpireDays;

    @TableField(updateStrategy = FieldStrategy.ALWAYS)
    private Boolean notifyEnabled;

    @TableField(updateStrategy = FieldStrategy.ALWAYS)
    private Integer notifyDays;

    private Integer receiveLimitPerDay;

    private Integer receiveCooldownDays;

}
