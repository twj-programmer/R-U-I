package com.meession.etm.module.crm.controller.admin.statistics;

import cn.idev.excel.annotation.ExcelProperty;
import com.meession.etm.module.crm.controller.admin.statistics.vo.customer.CrmStatisticsCustomerContractSummaryExportVO;
import com.meession.etm.module.crm.controller.admin.statistics.vo.customer.CrmStatisticsCustomerReqVO;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.Test;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;

import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class CrmStatisticsCustomerExportContractTest {

    @Test
    void exportEndpointShouldUseFrozenPathAndPermission() throws NoSuchMethodException {
        Method method = CrmStatisticsCustomerController.class.getMethod("exportContractSummary",
                CrmStatisticsCustomerReqVO.class, HttpServletResponse.class);

        GetMapping getMapping = method.getAnnotation(GetMapping.class);
        PreAuthorize preAuthorize = method.getAnnotation(PreAuthorize.class);
        assertNotNull(getMapping);
        assertNotNull(preAuthorize);
        assertEquals(List.of("/export-contract-summary"), Arrays.asList(getMapping.value()));
        assertEquals("@ss.hasPermission('crm:statistics-customer:export')", preAuthorize.value());
    }

    @Test
    void exportColumnsShouldMatchV15Contract() {
        List<Field> columns = Arrays.stream(CrmStatisticsCustomerContractSummaryExportVO.class.getDeclaredFields())
                .filter(field -> field.isAnnotationPresent(ExcelProperty.class))
                .sorted(Comparator.comparingInt(field -> field.getAnnotation(ExcelProperty.class).order()))
                .toList();

        assertEquals(10, columns.size());
        assertEquals(List.of("customerName", "contractName", "totalPrice", "receivablePrice", "industryId",
                        "source", "ownerUserName", "creatorUserName", "createTime", "orderDate"),
                columns.stream().map(Field::getName).toList());
        assertFalse(Arrays.stream(CrmStatisticsCustomerContractSummaryExportVO.class.getDeclaredFields())
                .anyMatch(field -> field.getName().equals("customerType")));
    }

    @Test
    void receivableDeletedConditionShouldRemainInLeftJoin() throws IOException {
        String resource = "mapper/statistics/CrmStatisticsCustomerMapper.xml";
        String xml;
        try (InputStream input = Thread.currentThread().getContextClassLoader().getResourceAsStream(resource)) {
            assertNotNull(input, resource);
            xml = new String(input.readAllBytes(), StandardCharsets.UTF_8);
        }

        int selectStart = xml.indexOf("<select id=\"selectContractSummary\"");
        int selectEnd = xml.indexOf("</select>", selectStart);
        assertTrue(selectStart >= 0 && selectEnd > selectStart);
        String select = xml.substring(selectStart, selectEnd);
        int whereStart = select.indexOf("WHERE");
        assertTrue(whereStart > 0);
        assertTrue(select.substring(0, whereStart).contains("AND receivable.deleted = 0"));
        assertFalse(select.substring(whereStart).contains("receivable.deleted = 0"));
        assertTrue(select.contains("IFNULL(receivable.price, 0) AS receivable_price"));
    }
}
