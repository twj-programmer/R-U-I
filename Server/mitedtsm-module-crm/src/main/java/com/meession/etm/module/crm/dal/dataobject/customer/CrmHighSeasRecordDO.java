package com.meession.etm.module.crm.dal.dataobject.customer;

import com.meession.etm.framework.mybatis.core.dataobject.BaseDO;
import com.baomidou.mybatisplus.annotation.*;
import lombok.*;

import java.time.LocalDateTime;

@TableName(value = "crm_high_seas_record")
@KeySequence("crm_high_seas_record_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CrmHighSeasRecordDO extends BaseDO {

    @TableId
    private Long id;

    private Long customerId;

    private String actionType;

    private Long beforeOwnerUserId;

    private Long afterOwnerUserId;

    private String reason;

    private Long operatorUserId;

    private LocalDateTime actionTime;

}