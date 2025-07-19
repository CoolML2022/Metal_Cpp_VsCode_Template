#pragma once
#include <iostream>
#include <vector>

class Matrix {
private:
    int m_rows;
    int m_cols;
    std::vector<float> m_data;

public:
    Matrix(int rows, int cols);
    Matrix(int rows, int cols, std::vector<float> data);
    int getRows() const;
    int getCols() const;
    float at(int r, int c) const;
    void print() const;
    float& at(int r, int c);
    void fill(float value);
    Matrix multiply_cpu(const Matrix& other) const;

    const std::vector<float>& data() const;
          std::vector<float>& data();
};