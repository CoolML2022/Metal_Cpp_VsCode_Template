#include "matrix.hpp"
#include "metal_wrapper.hpp"
#include <chrono>

int main() {
    Matrix A(800, 800);
    A.fill(2.0f);
    Matrix B(800, 800);
    B.fill(3.0f);

    
    auto start_cpu = std::chrono::high_resolution_clock::now();
    Matrix result_cpu = A.multiply_cpu(B);
    auto end_cpu = std::chrono::high_resolution_clock::now();
    auto duration_cpu = std::chrono::duration_cast<std::chrono::microseconds>(end_cpu - start_cpu);
    std::cout << "CPU time: " << duration_cpu.count() << " µs" << std::endl;

    auto start_gpu = std::chrono::high_resolution_clock::now();
    MetalComputeWrapper metal;
    Matrix result_gpu = metal.multiply(A, B);
    auto end_gpu = std::chrono::high_resolution_clock::now();
    auto duration_gpu = std::chrono::duration_cast<std::chrono::microseconds>(end_gpu - start_gpu);
    std::cout << "GPU time: " << duration_gpu.count() << " µs" << std::endl;

    //Matrix C = metal.multiply(A, B);
    //C.print();
    return 0;
}