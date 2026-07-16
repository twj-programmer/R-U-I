package com.meession.etm.module.crm.controller.admin.statistics;

import cn.idev.excel.annotation.ExcelProperty;
import cn.idev.excel.FastExcelFactory;
import cn.idev.excel.metadata.data.WriteCellData;
import cn.idev.excel.metadata.property.ExcelContentProperty;
import com.meession.etm.framework.common.biz.system.dict.DictDataCommonApi;
import com.meession.etm.framework.common.biz.system.dict.dto.DictDataRespDTO;
import com.meession.etm.framework.dict.core.DictFrameworkUtils;
import com.meession.etm.module.crm.controller.admin.statistics.vo.customer.CrmStatisticsCustomerContractSummaryExportVO;
import com.meession.etm.module.crm.controller.admin.statistics.vo.customer.CrmStatisticsCustomerReqVO;
import com.meession.etm.module.crm.controller.admin.statistics.vo.customer.CrmStatisticsCustomerContractSummaryRespVO;
import com.meession.etm.module.crm.controller.admin.statistics.vo.customer.CrmStatisticsDictFallbackConvert;
import com.meession.etm.module.crm.service.statistics.CrmStatisticsCustomerService;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.Test;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.web.bind.annotation.GetMapping;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.same;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import static com.meession.etm.module.crm.enums.DictTypeConstants.CRM_CUSTOMER_INDUSTRY;
import static com.meession.etm.module.crm.enums.DictTypeConstants.CRM_CUSTOMER_SOURCE;

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

    @Test
    void dictConverterShouldUseLabelEmptyAndRawIdFallbacks() throws NoSuchFieldException {
        DictDataCommonApi dictDataApi = mock(DictDataCommonApi.class);
        when(dictDataApi.getDictDataList(anyString())).thenReturn(Collections.emptyList());
        DictFrameworkUtils.init(dictDataApi);
        DictFrameworkUtils.clearCache();

        Field industryField = CrmStatisticsCustomerContractSummaryExportVO.class.getDeclaredField("industryId");
        ExcelContentProperty contentProperty = mock(ExcelContentProperty.class);
        when(contentProperty.getField()).thenReturn(industryField);
        CrmStatisticsDictFallbackConvert converter = new CrmStatisticsDictFallbackConvert();

        WriteCellData<String> empty = converter.convertToExcelData(null, contentProperty, null);
        WriteCellData<String> unresolved = converter.convertToExcelData(9876, contentProperty, null);
        assertEquals("", empty.getStringValue());
        assertEquals("9876", unresolved.getStringValue());
    }

    @Test
    void emptyExportShouldKeepFrozenHeadersAndFilename() throws IOException {
        CrmStatisticsCustomerService service = mock(CrmStatisticsCustomerService.class);
        CrmStatisticsCustomerController controller = new CrmStatisticsCustomerController();
        ReflectionTestUtils.setField(controller, "customerService", service);
        CrmStatisticsCustomerReqVO reqVO = new CrmStatisticsCustomerReqVO();
        when(service.getContractSummary(same(reqVO))).thenReturn(Collections.emptyList());
        initEmptyDictApi();

        MockHttpServletResponse response = new MockHttpServletResponse();
        controller.exportContractSummary(reqVO, response);

        verify(service).getContractSummary(same(reqVO));
        assertEquals("application/vnd.ms-excel;charset=UTF-8", response.getContentType());
        assertFilename(response);
        List<Map<Integer, String>> rows = readAllRows(response);
        assertEquals(1, rows.size());
        assertEquals(10, rows.get(0).size());
    }

    @Test
    void exportShouldReuseQueryRowsAndApplyV15DataRules() throws IOException {
        CrmStatisticsCustomerService service = mock(CrmStatisticsCustomerService.class);
        CrmStatisticsCustomerController controller = new CrmStatisticsCustomerController();
        ReflectionTestUtils.setField(controller, "customerService", service);
        CrmStatisticsCustomerReqVO reqVO = new CrmStatisticsCustomerReqVO();
        CrmStatisticsCustomerContractSummaryRespVO row = new CrmStatisticsCustomerContractSummaryRespVO();
        row.setCustomerName("Customer A");
        row.setContractName("Contract A");
        row.setTotalPrice(new BigDecimal("1234.56"));
        row.setReceivablePrice(new BigDecimal("0.00"));
        row.setIndustryId(101);
        row.setSource(999);
        row.setOwnerUserName("Owner A");
        row.setCreatorUserName("Creator A");
        row.setCreateTime(LocalDateTime.of(2026, 7, 16, 9, 30));
        row.setOrderDate(LocalDateTime.of(2026, 7, 16, 10, 30));
        when(service.getContractSummary(same(reqVO))).thenReturn(List.of(row));
        initDictApiWithIndustryLabel();

        MockHttpServletResponse response = new MockHttpServletResponse();
        controller.exportContractSummary(reqVO, response);

        verify(service).getContractSummary(same(reqVO));
        List<Map<Integer, String>> rows = readAllRows(response);
        assertEquals(2, rows.size());
        Map<Integer, String> exported = rows.get(1);
        assertEquals("Customer A", exported.get(0));
        assertEquals("Contract A", exported.get(1));
        assertEquals(0, new BigDecimal(exported.get(2)).compareTo(new BigDecimal("1234.56")));
        assertEquals(0, new BigDecimal(exported.get(3)).compareTo(new BigDecimal("0.00")));
        assertEquals("Software", exported.get(4));
        assertEquals("999", exported.get(5));
        assertEquals("Owner A", exported.get(6));
        assertEquals("Creator A", exported.get(7));
        assertEquals("2026-07-16 09:30:00", exported.get(8));
        assertEquals("2026-07-16 10:30:00", exported.get(9));
    }

    private static void initEmptyDictApi() {
        DictDataCommonApi dictDataApi = mock(DictDataCommonApi.class);
        when(dictDataApi.getDictDataList(anyString())).thenReturn(Collections.emptyList());
        DictFrameworkUtils.init(dictDataApi);
        DictFrameworkUtils.clearCache();
    }

    private static void initDictApiWithIndustryLabel() {
        DictDataRespDTO industry = new DictDataRespDTO();
        industry.setDictType(CRM_CUSTOMER_INDUSTRY);
        industry.setValue("101");
        industry.setLabel("Software");
        DictDataCommonApi dictDataApi = mock(DictDataCommonApi.class);
        when(dictDataApi.getDictDataList(CRM_CUSTOMER_INDUSTRY)).thenReturn(List.of(industry));
        when(dictDataApi.getDictDataList(CRM_CUSTOMER_SOURCE)).thenReturn(Collections.emptyList());
        DictFrameworkUtils.init(dictDataApi);
        DictFrameworkUtils.clearCache();
    }

    private static List<Map<Integer, String>> readAllRows(MockHttpServletResponse response) {
        return FastExcelFactory.read(new ByteArrayInputStream(response.getContentAsByteArray()))
                .headRowNumber(0)
                .doReadAllSync();
    }

    private static void assertFilename(MockHttpServletResponse response) {
        String disposition = response.getHeader("Content-Disposition");
        assertNotNull(disposition);
        String encodedFilename = disposition.substring(disposition.indexOf('=') + 1);
        String filename = URLDecoder.decode(encodedFilename, StandardCharsets.UTF_8);
        assertTrue(filename.matches("客户转化明细_\\d{14}\\.xlsx"), filename);
    }
}
