// 23计科4班 黄金戈
package com.meession.etm.module.crm.controller.admin.business.vo.business;

import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
public class CrmBusinessQuotationRespVO {
    private Long id;
    private Integer version;
    private BigDecimal totalProductPrice;
    private BigDecimal discountPercent;
    private BigDecimal discountAmount;
    private BigDecimal totalPrice;
    private List<Product> products;

    @Data
    public static class Product {
        private Long productId;
        private BigDecimal productPrice;
        private BigDecimal businessPrice;
        private BigDecimal count;
        private BigDecimal totalPrice;
    }
}
