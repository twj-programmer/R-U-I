package com.meession.etm.module.crm.service.customer;

import com.meession.etm.framework.mybatis.core.query.LambdaQueryWrapperX;
import com.meession.etm.module.crm.controller.admin.customer.vo.customer.CrmCustomerDuplicateCheckRespVO;
import com.meession.etm.module.crm.controller.admin.customer.vo.customer.CrmCustomerDuplicateItemVO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerDO;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerMapper;
import com.meession.etm.module.crm.service.customer.bo.CrmCustomerDuplicateCheckBO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class CrmCustomerDuplicateCheckServiceImpl implements CrmCustomerDuplicateCheckService {

    private static final double SIMILARITY_THRESHOLD = 0.80;

    private final CrmCustomerMapper customerMapper;

    @Override
    @Transactional(readOnly = true)
    public CrmCustomerDuplicateCheckRespVO checkDuplicate(CrmCustomerDuplicateCheckBO checkBO) {
        CrmCustomerDuplicateCheckRespVO respVO = new CrmCustomerDuplicateCheckRespVO();

        String normalizedName = normalizeName(checkBO.getName());
        String normalizedMobile = normalizeMobile(checkBO.getMobile());

        List<CrmCustomerDO> candidates = findCandidateCustomers(checkBO, normalizedName, normalizedMobile);

        List<CrmCustomerDuplicateItemVO> duplicates = candidates.stream()
                .map(customer -> buildDuplicateItem(customer, normalizedName, normalizedMobile))
                .filter(item -> item.getMatchType() != null)
                .sorted(Comparator.comparing(CrmCustomerDuplicateItemVO::getMatchType)
                        .thenComparing(CrmCustomerDuplicateItemVO::getSimilarity, Comparator.reverseOrder())
                        .thenComparing(CrmCustomerDuplicateItemVO::getId, Comparator.reverseOrder()))
                .collect(Collectors.toList());

        respVO.setHasDuplicate(!duplicates.isEmpty());
        respVO.setCandidates(duplicates);
        return respVO;
    }

    private List<CrmCustomerDO> findCandidateCustomers(CrmCustomerDuplicateCheckBO checkBO, String normalizedName, String normalizedMobile) {
        LambdaQueryWrapperX<CrmCustomerDO> query = new LambdaQueryWrapperX<>();
        query.neIfPresent(CrmCustomerDO::getId, checkBO.getExcludeId());
        query.eq(CrmCustomerDO::getDeleted, false);

        boolean hasName = normalizedName != null && !normalizedName.isEmpty();
        boolean hasMobile = normalizedMobile != null && !normalizedMobile.isEmpty();

        List<CrmCustomerDO> candidates = new ArrayList<>();

        if (hasMobile) {
            query.clear();
            query.neIfPresent(CrmCustomerDO::getId, checkBO.getExcludeId());
            query.eq(CrmCustomerDO::getDeleted, false);
            query.eq(CrmCustomerDO::getMobile, normalizedMobile);
            candidates.addAll(customerMapper.selectList(query));
        }

        if (hasName) {
            query.clear();
            query.neIfPresent(CrmCustomerDO::getId, checkBO.getExcludeId());
            query.eq(CrmCustomerDO::getDeleted, false);
            query.like(CrmCustomerDO::getName, normalizedName.charAt(0));
            List<CrmCustomerDO> nameCandidates = customerMapper.selectList(query);

            for (CrmCustomerDO candidate : nameCandidates) {
                String candidateNormalizedName = normalizeName(candidate.getName());
                if (candidateNormalizedName != null && !candidateNormalizedName.isEmpty()) {
                    double similarity = calculateLevenshteinSimilarity(normalizedName, candidateNormalizedName);
                    if (similarity >= SIMILARITY_THRESHOLD) {
                        if (!candidates.contains(candidate)) {
                            candidates.add(candidate);
                        }
                    }
                }
            }
        }

        return candidates;
    }

    private CrmCustomerDuplicateItemVO buildDuplicateItem(CrmCustomerDO customer, String normalizedName, String normalizedMobile) {
        CrmCustomerDuplicateItemVO item = new CrmCustomerDuplicateItemVO();
        item.setId(customer.getId());
        item.setName(customer.getName());
        item.setMobileMasked(maskMobile(customer.getMobile()));

        String candidateNormalizedName = normalizeName(customer.getName());
        String candidateNormalizedMobile = normalizeMobile(customer.getMobile());

        double rawSimilarity = 0.0;
        if (normalizedName != null && !normalizedName.isEmpty() && candidateNormalizedName != null) {
            rawSimilarity = calculateLevenshteinSimilarity(normalizedName, candidateNormalizedName);
        }
        BigDecimal nameSimilarity = BigDecimal.valueOf(rawSimilarity).setScale(2, java.math.RoundingMode.HALF_UP);
        item.setSimilarity(nameSimilarity);

        if (normalizedMobile != null && !normalizedMobile.isEmpty() 
                && candidateNormalizedMobile != null && candidateNormalizedMobile.equals(normalizedMobile)) {
            item.setMatchType("STRONG");
        } else if (rawSimilarity >= SIMILARITY_THRESHOLD) {
            item.setMatchType("SUSPECT");
        }

        return item;
    }

    private String normalizeName(String name) {
        if (name == null) {
            return null;
        }
        String normalized = name.trim();
        normalized = fullWidthToHalfWidth(normalized);
        normalized = normalized.toLowerCase();
        normalized = normalized.replaceAll("\\s+", "");
        normalized = normalized.replaceAll("[\\p{Punct}\\p{Space}\\p{Symbol}\\p{Currency}\\p{Number}]", "");
        return normalized;
    }

    private String fullWidthToHalfWidth(String text) {
        if (text == null) {
            return null;
        }
        StringBuilder sb = new StringBuilder();
        for (char c : text.toCharArray()) {
            if (c >= '\uFF01' && c <= '\uFF5E') {
                sb.append((char) (c - 0xFEE0));
            } else if (c == '\u3000') {
                sb.append(' ');
            } else {
                sb.append(c);
            }
        }
        return sb.toString();
    }

    private String normalizeMobile(String mobile) {
        if (mobile == null) {
            return null;
        }
        String normalized = fullWidthToHalfWidth(mobile);
        return normalized.replaceAll("[^0-9]", "");
    }

    private String maskMobile(String mobile) {
        if (mobile == null || mobile.length() < 7) {
            return null;
        }
        String normalized = normalizeMobile(mobile);
        if (normalized == null || normalized.length() < 7) {
            return null;
        }
        return normalized.substring(0, 3) + "****" + normalized.substring(normalized.length() - 4);
    }

    private double calculateLevenshteinSimilarity(String s1, String s2) {
        if (s1 == null || s2 == null || s1.isEmpty() || s2.isEmpty()) {
            return 0.0;
        }
        int len1 = s1.length();
        int len2 = s2.length();

        int[][] dp = new int[len1 + 1][len2 + 1];

        for (int i = 0; i <= len1; i++) {
            dp[i][0] = i;
        }
        for (int j = 0; j <= len2; j++) {
            dp[0][j] = j;
        }

        for (int i = 1; i <= len1; i++) {
            for (int j = 1; j <= len2; j++) {
                int cost = s1.charAt(i - 1) == s2.charAt(j - 1) ? 0 : 1;
                dp[i][j] = Math.min(Math.min(dp[i - 1][j] + 1, dp[i][j - 1] + 1), dp[i - 1][j - 1] + cost);
            }
        }

        int distance = dp[len1][len2];
        int maxLen = Math.max(len1, len2);

        return maxLen == 0 ? 0 : 1.0 - (double) distance / maxLen;
    }

}