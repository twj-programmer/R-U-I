// 23计科4班 黄金戈
package com.meession.etm.module.crm.dal.mysql.business;


import com.meession.etm.framework.mybatis.core.mapper.BaseMapperX;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessProductDO;
import org.apache.ibatis.annotations.Mapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;

import java.util.List;

/**
 * 商机产品 Mapper
 *
 * @author lzxhqs
 */
@Mapper
public interface CrmBusinessProductMapper extends BaseMapperX<CrmBusinessProductDO> {

    default List<CrmBusinessProductDO> selectListByBusinessId(Long businessId) {
        return selectList(CrmBusinessProductDO::getBusinessId, businessId);
    }

    default int deleteByBusinessId(Long businessId) {
        return delete(new LambdaQueryWrapper<CrmBusinessProductDO>()
                .eq(CrmBusinessProductDO::getBusinessId, businessId));
    }

}
