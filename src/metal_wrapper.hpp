#pragma once

#include "matrix.hpp"

class MetalComputeWrapper {
public:
    MetalComputeWrapper();  // optionaler Konstruktor
    Matrix multiply(const Matrix& A, const Matrix& B);
};