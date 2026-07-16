package com.meession.etm.module.crm.controller.admin.statistics.vo.customer;

import com.meession.etm.framework.excel.core.annotations.DictFormat;
import cn.idev.excel.annotation.ExcelProperty;
import cn.idev.excel.annotation.format.DateTimeFormat;
import cn.idev.excel.annotation.format.NumberFormat;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import static com.meession.etm.module.crm.enums.DictTypeConstants.CRM_CUSTOMER_INDUSTRY;
import static com.meession.etm.module.crm.enums.DictTypeConstants.CRM_CUSTOMER_SOURCE;

/**
 * CRM 客户转化明细导出 VO。
 */
@Data
public class CrmStatisticsCustomerContractSummaryExportVO {

    @ExcelProperty(value = "客户名称", order = 1)
    private String customerName;

    @ExcelProperty(value = "首次合同名称", order = 2)
    private String contractName;

    @ExcelProperty(value = "合同金额", order = 3)
    @NumberFormat("0.00")
    private BigDecimal totalPrice;

    @ExcelProperty(value = "回款金额", order = 4)
    @NumberFormat("0.00")
    private BigDecimal receivablePrice;

    @ExcelProperty(value = "客户行业", order = 5, converter = CrmStatisticsDictFallbackConvert.class)
    @DictFormat(CRM_CUSTOMER_INDUSTRY)
    private Integer industryId;

    @ExcelProperty(value = "客户来源", order = 6, converter = CrmStatisticsDictFallbackConvert.class)
    @DictFormat(CRM_CUSTOMER_SOURCE)
    private Integer source;

    @ExcelProperty(value = "负责人", order = 7)
    private String ownerUserName;

    @ExcelProperty(value = "创建人", order = 8)
    private String creatorUserName;

    @ExcelProperty(value = "创建时间", order = 9)
    @DateTimeFormat("yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;

    @ExcelProperty(value = "签约时间", order = 10)
    @DateTimeFormat("yyyy-MM-dd HH:mm:ss")
    private LocalDateTime orderDate;

}
