#include <iostream>
#include <vector>
#include "matrix.hpp"

Matrix::Matrix(int rows, int cols) : m_rows(rows), m_cols(cols), m_data(rows * cols, 0.0f) {}

Matrix::Matrix(int rows, int cols, std::vector<float> data) : m_rows(rows), m_cols(cols), m_data(data) {}

int Matrix::getRows() const{
    return m_rows;
}

int Matrix::getCols() const{
    return m_cols;
}

float Matrix::at(int r, int c) const {
    return m_data[r * m_cols + c];
}

float& Matrix::at(int r, int c) {
    return m_data[r * m_cols + c];
}

void Matrix::print() const {
    std::string s;
    for (int r = 0; r < m_rows; r++) {
        for (int c = 0; c < m_cols; c++) {
            s.append(std::to_string(at(r, c))).append(" ");
        }
        s.append("\n");
    }
    std::cout << s;
}

Matrix Matrix::multiply_cpu(const Matrix& other) const {
    if (m_cols != other.getRows())
        throw std::runtime_error("Matrix dimension mismatch");

    Matrix result(m_rows, other.getCols());

    for (int r = 0; r < m_rows; ++r) {
        for (int c = 0; c < other.getCols(); ++c) {
            float sum = 0.0f;
            for (int k = 0; k < m_cols; ++k) {
                sum += at(r, k) * other.at(k, c);
            }
            result.at(r, c) = sum;
        }
    }

    return result;
}

void Matrix::fill(float value) {
    std::fill(m_data.begin(), m_data.end(), value);
}

const std::vector<float>& Matrix::data() const { return m_data; }

std::vector<float>& Matrix::data() { return m_data; }



