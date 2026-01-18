import 'package:flutter/material.dart';

enum FinancialStatus {
  good,    // 저평가, 우수, 안정적
  normal,  // 보통
  caution, // 고평가, 저조, 주의
}

class FinancialEvaluation {
  final String label;
  final Color color;
  final FinancialStatus status;

  const FinancialEvaluation({
    required this.label,
    required this.color,
    required this.status,
  });
}

class FinancialEvaluator {
  
  // 1. PER (주가수익비율)
  static FinancialEvaluation evaluatePER(double value) {
    if (value <= 0) {
      // 적자 기업 등
      return _caution('정보없음'); // 혹은 N/A
    }
    if (value < 10) {
      return _good('저평가'); // 10배 미만
    } else if (value < 20) {
      return _normal('보통'); // 10~20배
    } else {
      return _caution('고평가'); // 20배 이상
    }
  }

  // 2. ROE (자기자본이익률)
  static FinancialEvaluation evaluateROE(double value) {
    if (value < 0) {
      return _caution('적자'); // 적자 기업
    }
    if (value >= 15) {
      return _good('우수'); // 15% 이상
    } else if (value >= 5) {
      return _normal('보통'); // 5~15%
    } else {
      return _caution('저조'); // 5% 미만
    }
  }

  // 3. PBR (주가순자산비율)
  static FinancialEvaluation evaluatePBR(double value) {
    if (value <= 0) {
      return _caution('정보없음'); // 자본잠식 등
    }
    if (value < 1) {
      return _good('저평가'); // 1배 미만
    } else if (value <= 3) {
      return _normal('보통'); // 1~3배
    } else {
      return _caution('고평가'); // 3배 초과
    }
  }

  // 4. 배당수익률
  static FinancialEvaluation evaluateDividendYield(double value) {
    if (value >= 3) {
      return _good('고배당'); // 3% 이상
    } else if (value >= 1) {
      return _normal('보통'); // 1~3%
    } else {
      return _caution('낮음'); // 1% 미만
    }
  }

  // 5. 부채비율
  static FinancialEvaluation evaluateDebtRatio(double value) {
    if (value < 100) {
      return _good('안정적'); // 100% 미만
    } else if (value <= 200) {
      return _normal('보통'); // 100~200%
    } else {
      return _caution('주의'); // 200% 초과
    }
  }

  // --- Helpers ---
  
  static FinancialEvaluation _good(String label) {
    return FinancialEvaluation(
      label: label,
      color: const Color(0xFF4CAF50), // Green
      status: FinancialStatus.good,
    );
  }

  static FinancialEvaluation _normal(String label) {
    return FinancialEvaluation(
      label: label,
      color: const Color(0xFFFF9800), // Orange
      status: FinancialStatus.normal,
    );
  }

  static FinancialEvaluation _caution(String label) {
    return FinancialEvaluation(
      label: label,
      color: const Color(0xFFF44336), // Red
      status: FinancialStatus.caution,
    );
  }
}
