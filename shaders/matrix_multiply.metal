#include <metal_stdlib>
using namespace metal;

kernel void matrix_multiply(
    device const float* A [[buffer(0)]],
    device const float* B [[buffer(1)]],
    device float* C [[buffer(2)]],
    constant uint& M [[buffer(3)]], //Zeilen von A
    constant uint& K [[buffer(4)]], //Spalten von A / Zeilen von B
    constant uint& N [[buffer(5)]], //Spalten von B
    uint gid [[thread_position_in_grid]]
) {
    uint row = gid / N;
    uint col = gid % N;

    if (row >= M || col >= N) return;

    float sum = 0.0;


    for(uint k = 0; k < K; k++) {
        sum += A[row * K +k] * B[k * N + col];
    }

    C[row * N + col] = sum;
}