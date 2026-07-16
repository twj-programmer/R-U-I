package com.meession.etm.module.crm.controller.admin.statistics.vo.customer;

import com.meession.etm.framework.dict.core.DictFrameworkUtils;
import com.meession.etm.framework.excel.core.annotations.DictFormat;
import cn.idev.excel.converters.Converter;
import cn.idev.excel.enums.CellDataTypeEnum;
import cn.idev.excel.metadata.GlobalConfiguration;
import cn.idev.excel.metadata.data.ReadCellData;
import cn.idev.excel.metadata.data.WriteCellData;
import cn.idev.excel.metadata.property.ExcelContentProperty;

/**
 * CRM 统计导出字典转换器。
 *
 * <p>与公共字典转换器不同，字典值无法解析时保留原始编号，满足 D2-STAT-01 的导出契约。</p>
 */
public class CrmStatisticsDictFallbackConvert implements Converter<Object> {

    @Override
    public Class<?> supportJavaTypeKey() {
        throw new UnsupportedOperationException("仅通过字段注解使用");
    }

    @Override
    public CellDataTypeEnum supportExcelTypeKey() {
        throw new UnsupportedOperationException("仅支持导出");
    }

    @Override
    public Object convertToJavaData(ReadCellData<?> cellData, ExcelContentProperty contentProperty,
                                    GlobalConfiguration globalConfiguration) {
        throw new UnsupportedOperationException("仅支持导出");
    }

    @Override
    public WriteCellData<String> convertToExcelData(Object object, ExcelContentProperty contentProperty,
                                                     GlobalConfiguration globalConfiguration) {
        if (object == null) {
            return new WriteCellData<>("");
        }
        String value = String.valueOf(object);
        String type = contentProperty.getField().getAnnotation(DictFormat.class).value();
        String label = DictFrameworkUtils.parseDictDataLabel(type, value);
        return new WriteCellData<>(label != null ? label : value);
    }

}
